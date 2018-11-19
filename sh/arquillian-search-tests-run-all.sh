#!/bin/sh

set -o errexit ; set -o nounset

RUN_ALL_TESTS=true
REDEPLOY_ALL_DEPENDENCIES=false
JOURNAL_IN_SPLITREPO=false


#
# SEE: https://github.com/liferay/liferay-portal/blob/19ab16500f013bcfdb9283c6567f70ee9b531ba7/test.properties#L1553-L1581
#
function run_all_tests()
{
# portal-search-test

test_run portal-search/portal-search-test \
	*Test

# Highest coverage of Search

test_run document-library/document-library-test \
	com.liferay.document.library.search.test.*Test \
	com.liferay.document.library.trash.test.DLFileEntryTrashHandlerTest \
	com.liferay.document.library.trash.test.DLFolderTrashHandlerTest 

test_run calendar/calendar-test \
	com.liferay.calendar.search.test.*Test

test_run users-admin/users-admin-test \
	com.liferay.users.admin.indexer.test.*Test

test_run asset/asset-test \
	com.liferay.asset.search.test.*Test \
	com.liferay.asset.service.test.AssetVocabularyServiceTest \
	com.liferay.asset.util.test.AssetHelperTest

test_run asset/asset-categories-test \
	*.search.test.*Test 

test_run_journal \
	com.liferay.journal.asset.test.JournalArticleAssetSearchTest \
	com.liferay.journal.search.test.*Test \
	com.liferay.journal.service.test.JournalArticleExpirationTest \
	com.liferay.journal.service.test.JournalArticleIndexVersionsTest \
	com.liferay.journal.service.test.JournalArticleScheduledTest \
	com.liferay.journal.trash.test.JournalArticleTrashHandlerTest \
	com.liferay.journal.trash.test.JournalFolderTrashHandlerTest

test_run sharing/sharing-search-test \
	*Test

# All other tests using Search in some capacity

test_run blogs/blogs-test \
	com.liferay.blogs.asset.test.BlogsEntryAssetSearchTest \
	com.liferay.blogs.search.test.*Test \
	com.liferay.blogs.service.test.BlogsEntryStatusTransitionTest \
	com.liferay.blogs.service.test.BlogsEntryTrashHandlerTest

test_run bookmarks/bookmarks-test \
	com.liferay.bookmarks.search.test.*Test \
	com.liferay.bookmarks.service.test.BookmarksFolderServiceTest \
	com.liferay.bookmarks.trash.test.BookmarksEntryTrashHandlerTest \
	com.liferay.bookmarks.trash.test.BookmarksFolderTrashHandlerTest

test_run message-boards/message-boards-test \
	com.liferay.message.boards.search.test.*Test \
	com.liferay.message.boards.trash.test.MBThreadTrashHandlerTest

test_run wiki/wiki-test \
	com.liferay.wiki.search.test.*Test \
	com.liferay.wiki.trash.test.WikiPageTrashHandlerTest

test_run dynamic-data-lists/dynamic-data-lists-test \
	com.liferay.dynamic.data.lists.search.test.*Test

test_run user-groups-admin/user-groups-admin-test \
	com.liferay.user.groups.admin.web.internal.search.test.*Test 

test_run asset/asset-publisher-test \
	com.liferay.asset.publisher.lar.test.AssetPublisherExportImportTest

test_run portal-workflow/portal-workflow-kaleo-test \
	com.liferay.portal.workflow.kaleo.runtime.integration.internal.test.WorkflowTaskManagerImplTest
}

function run_some_tests()
{
#	

if [ 0 = true ]
then


# this test creates a DL file and never removes it -- search engine is polluted
test_run document-library/document-library-test \
	com.liferay.document.library.webdav.test.WebDAVLitmusBasicTest

#
:
fi

#
:	
}

function ant_deploy()
{
	local subdir=$1

	figlet -f mini ant deploy $1 || true

	cd ${LIFERAY_PORTAL_DIR}/$subdir
	ant deploy install-portal-snapshot
}

function gradle_deploy()
{
	local subdir=$1

	figlet -f mini gradle deploy $1 || true

	cd ${LIFERAY_PORTAL_DIR}/$subdir
	${LIFERAY_PORTAL_DIR}/gradlew deploy
}

function do_test_run()
{
	local directory=$1
	local no_settings_gradle=$2
	shift 2
	local tests=( "$@" ) 

	figlet -f digital RUN $directory || true

	cd $directory

	if [ "$no_settings_gradle" = true ]
	then
		mv settings.gradle settings.gradle.ORIGINAL || true
		mv ../settings.gradle ../settings.gradle.ORIGINAL || true
	fi

	local gwtests=()
	for test in "${tests[@]}"; do
		gwtests+=("--tests")
		gwtests+=($test)
	done

	${LIFERAY_PORTAL_DIR}/gradlew cleanTestIntegration testIntegration --stacktrace "${gwtests[@]}" || { 
		RETURN_CODE=$?
		echo ${RETURN_CODE}
		echo "*** IGNORING BOGUS FAILURE & MOVING ON! :-)"
	}

	if [ "$no_settings_gradle" = true ]
	then
		mv settings.gradle.ORIGINAL settings.gradle || true
		mv ../settings.gradle.ORIGINAL ../settings.gradle || true	
	fi

	open build/reports/tests/testIntegration/index.html || true
}

function test_run()
{
	local subdir=$1
	shift 1
	local tests=( "$@" ) 

	local directory=${LIFERAY_PORTAL_DIR}/modules/apps/$subdir
	local no_settings_gradle=true

	do_test_run $directory $no_settings_gradle "${tests[@]}"
}

function test_run_splitrepo()
{
	local splitrepo=$1
	shift 1
	local tests=( "$@" ) 

	local directory=${LIFERAY_PORTAL_DIR}/../$splitrepo
	local no_settings_gradle=false

	do_test_run $directory $no_settings_gradle "${tests[@]}"
}

function test_run_journal()
{
	local tests=( "$@" ) 

if [ "$JOURNAL_IN_SPLITREPO" = true ]
then

test_run_splitrepo com-liferay-journal/journal-test "${tests[@]}"

else

test_run journal/journal-test "${tests[@]}"

fi

}

function redeploy_all_dependencies() 
{
ant_deploy portal-kernel
ant_deploy portal-test
ant_deploy portal-test-integration
gradle_deploy modules/apps/forms-and-workflow/dynamic-data-mapping/dynamic-data-mapping-test-util
}

function main() 
{

if [ "$REDEPLOY_ALL_DEPENDENCIES" = true ] 
then
	redeploy_all_dependencies
fi

if [ "$RUN_ALL_TESTS" = true ]
then
	run_all_tests
else
	run_some_tests
fi

}


						main