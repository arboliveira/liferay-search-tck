#!/bin/sh

set -o errexit ; set -o nounset

RUN_ALL_TESTS=true
REDEPLOY_ALL_DEPENDENCIES=false
JOURNAL_IN_SPLITREPO=false


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

function redeploy_all_dependencies() 
{
ant_deploy portal-kernel
ant_deploy portal-test
ant_deploy portal-test-integration
gradle_deploy modules/apps/forms-and-workflow/dynamic-data-mapping/dynamic-data-mapping-test-util
}

#
# SEE: com.liferay.portal.search.tck.AllSearchTestsArquillian
#
function run_all_tests()
{
test_run foundation/portal-search/portal-search-test com.liferay.portal.search.facet.faceted.searcher.test.AssetTagNamesFacetTest
test_run foundation/portal-search/portal-search-test com.liferay.portal.search.facet.faceted.searcher.test.FacetedSearcherTest
test_run foundation/portal-search/portal-search-test com.liferay.portal.search.facet.faceted.searcher.test.ModifiedFacetTest
test_run foundation/portal-search/portal-search-test com.liferay.portal.search.facet.faceted.searcher.test.ScopeFacetTest
test_run foundation/portal-search/portal-search-test com.liferay.portal.search.indexer.test.IndexerPostProcessorRegistryTest
test_run foundation/portal-search/portal-search-test com.liferay.portal.search.internal.test.SearchPermissionCheckerTest

test_run collaboration/bookmarks/bookmarks-test com.liferay.bookmarks.search.test.BookmarksEntrySearchTest 
test_run collaboration/bookmarks/bookmarks-test com.liferay.bookmarks.search.test.BookmarksFolderSearchTest

test_run forms-and-workflow/calendar/calendar-test com.liferay.calendar.search.test.CalendarSearcherTest

test_run collaboration/document-library/document-library-test com.liferay.document.library.search.test.DLFileEntrySearchTest

test_run forms-and-workflow/dynamic-data-lists/dynamic-data-lists-test com.liferay.dynamic.data.lists.search.test.DDLRecordSearchTest

if [ "$JOURNAL_IN_SPLITREPO" = true ]
then

test_run_splitrepo com-liferay-journal/journal-test com.liferay.journal.asset.test.JournalArticleAssetSearchTest
test_run_splitrepo com-liferay-journal/journal-test com.liferay.journal.search.test.JournalArticleIndexableTest
test_run_splitrepo com-liferay-journal/journal-test com.liferay.journal.service.test.JournalArticleIndexVersionsTest
test_run_splitrepo com-liferay-journal/journal-test com.liferay.journal.search.test.JournalArticleSearchTest
test_run_splitrepo com-liferay-journal/journal-test com.liferay.journal.search.test.JournalFolderSearchTest
test_run_splitrepo com-liferay-journal/journal-test com.liferay.journal.search.test.JournalIndexerTest

else

test_run web-experience/journal/journal-test com.liferay.journal.asset.test.JournalArticleAssetSearchTest
test_run web-experience/journal/journal-test com.liferay.journal.search.test.JournalArticleIndexableTest
test_run web-experience/journal/journal-test com.liferay.journal.service.test.JournalArticleIndexVersionsTest
test_run web-experience/journal/journal-test com.liferay.journal.search.test.JournalArticleSearchTest
test_run web-experience/journal/journal-test com.liferay.journal.search.test.JournalFolderSearchTest
test_run web-experience/journal/journal-test com.liferay.journal.search.test.JournalIndexerTest

fi

test_run collaboration/wiki/wiki-test com.liferay.wiki.search.test.WikiPageSearchTest
}

function run_some_tests()
{
test_run_splitrepo com-liferay-journal/journal-test com.liferay.journal.search.test.JournalArticleIndexerLocalizedContentTest

test_run web-experience/journal/journal-test com.liferay.journal.asset.test.JournalArticleAssetSearchTest.testOrderByTitle*
}

function ant_deploy()
{
	subdir=$1

	figlet -f mini ant deploy $1 || true

	cd ${LIFERAY_PORTAL_DIR}/$subdir
	ant deploy install-portal-snapshot
}

function gradle_deploy()
{
	subdir=$1

	figlet -f mini gradle deploy $1 || true

	cd ${LIFERAY_PORTAL_DIR}/$subdir
	${LIFERAY_PORTAL_DIR}/gradlew deploy
}

function do_test_run()
{
	directory=$1
	tests=$2
	no_settings_gradle=$3

	figlet -f digital RUN $directory || true

	cd $directory

	if [ "$no_settings_gradle" = true ]
	then
		mv settings.gradle settings.gradle.ORIGINAL || true
		mv ../settings.gradle ../settings.gradle.ORIGINAL || true
	fi

	${LIFERAY_PORTAL_DIR}/gradlew testIntegration --tests $tests --stacktrace || { 
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
	subdir=$1
	tests=$2

	directory=${LIFERAY_PORTAL_DIR}/modules/apps/$subdir
	no_settings_gradle=true

	do_test_run $directory $tests $no_settings_gradle
}

function test_run_splitrepo()
{
	splitrepo=$1
	tests=$2

	directory=${LIFERAY_PORTAL_DIR}/../$splitrepo
	no_settings_gradle=false

	do_test_run $directory $tests $no_settings_gradle
}


main
