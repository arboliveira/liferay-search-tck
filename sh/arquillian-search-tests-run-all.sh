#!/bin/sh

set -o errexit ; set -o nounset

RUN_ALL_TESTS=${RUN_ALL_TESTS:=true}
OPEN_TEST_REPORTS_IN_BROWSER=${OPEN_TEST_REPORTS_IN_BROWSER:=false}
APP_SERVER_PARENT_DIR=${APP_SERVER_PARENT_DIR:=""}
REDEPLOY_ALL_DEPENDENCIES=${REDEPLOY_ALL_DEPENDENCIES:=false}
JOURNAL_IN_SPLITREPO=${JOURNAL_IN_SPLITREPO:=false}



#
# SEE: https://github.com/liferay/liferay-portal/blob/972f280bde2e2c69027588eb553b065a59eef3b4/test.properties#L1812-L1843
#
function run_all_tests()
{
# portal-search-test

test_run portal-search/portal-search-test \
	*Test

# Highest coverage of Search

test_run document-library/document-library-test \
	*.search.*Test \
	com.liferay.document.library.trash.test.DLFileEntryTrashHandlerTest \
	com.liferay.document.library.trash.test.DLFolderTrashHandlerTest 

test_run calendar/calendar-test \
	*.search.*Test

test_run users-admin/users-admin-test \
	com.liferay.users.admin.indexer.test.*Test

test_run asset/asset-test \
	*.search.*Test \
	com.liferay.asset.service.test.AssetVocabularyServiceTest \
	com.liferay.asset.util.test.AssetHelperTest

test_run asset/asset-categories-test \
	*.search.*Test 

test_run_journal \
	*.search.*Test \
	com.liferay.journal.asset.test.JournalArticleAssetSearchTest \
	com.liferay.journal.service.test.JournalArticleExpirationTest \
	com.liferay.journal.service.test.JournalArticleIndexVersionsTest \
	com.liferay.journal.service.test.JournalArticleScheduledTest \
	com.liferay.journal.trash.test.JournalArticleTrashHandlerTest \
	com.liferay.journal.trash.test.JournalFolderTrashHandlerTest

test_run sharing/sharing-search-test \
	*Test

# All other tests using Search in some capacity

test_run blogs/blogs-test \
	*.search.*Test \
	com.liferay.blogs.asset.test.BlogsEntryAssetSearchTest \
	com.liferay.blogs.service.test.BlogsEntryStatusTransitionTest \
	com.liferay.blogs.service.test.BlogsEntryTrashHandlerTest

test_run bookmarks/bookmarks-test \
	*.search.*Test \
	com.liferay.bookmarks.service.test.BookmarksFolderServiceTest \
	com.liferay.bookmarks.trash.test.BookmarksEntryTrashHandlerTest \
	com.liferay.bookmarks.trash.test.BookmarksFolderTrashHandlerTest

test_run message-boards/message-boards-test \
	*.search.*Test \
	com.liferay.message.boards.trash.test.MBThreadTrashHandlerTest

test_run wiki/wiki-test \
	*.search.*Test \
	com.liferay.wiki.trash.test.WikiPageTrashHandlerTest

test_run dynamic-data-lists/dynamic-data-lists-test \
	*.search.*Test

test_run user-groups-admin/user-groups-admin-test \
	*.search.*Test 

test_run asset/asset-publisher-test \
	com.liferay.asset.publisher.lar.test.AssetPublisherExportImportTest

test_run portal-workflow/portal-workflow-kaleo-test \
	com.liferay.portal.workflow.kaleo.internal.runtime.integration.test.WorkflowTaskManagerImplTest

test_run layout/layout-test \
	*.search.*Test
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

	local arg__app_server_parent_dir=()

	if [ "$APP_SERVER_PARENT_DIR" = "" ]
	then
		arg__app_server_parent_dir=""		
	else
		arg__app_server_parent_dir="-Dapp.server.parent.dir=$APP_SERVER_PARENT_DIR"
	fi

	${LIFERAY_PORTAL_DIR}/gradlew cleanTestIntegration testIntegration --stacktrace \
		${arg__app_server_parent_dir} -Dsetup.wizard.enabled=false "${gwtests[@]}"

#	${LIFERAY_PORTAL_DIR}/gradlew cleanTestIntegration testIntegration --stacktrace \
#		${arg__app_server_parent_dir} -Dsetup.wizard.enabled=false "${gwtests[@]}" \
#	|| \
#	{ 
#		RETURN_CODE=$?
#		echo ${RETURN_CODE}
#		echo "*** IGNORING BOGUS FAILURE & MOVING ON! :-)"
#	}

	if [ "$no_settings_gradle" = true ]
	then
		mv settings.gradle.ORIGINAL settings.gradle || true
		mv ../settings.gradle.ORIGINAL ../settings.gradle || true	
	fi

	if [ "$OPEN_TEST_REPORTS_IN_BROWSER" = true ]
	then
		open build/reports/tests/testIntegration/index.html || true
	fi
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