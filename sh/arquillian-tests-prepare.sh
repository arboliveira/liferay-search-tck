#!/bin/sh

set -o errexit ; set -o nounset

RUN_ALL_TESTS=false
REDEPLOY_ALL_DEPENDENCIES=false


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
test_run modules/apps/foundation/portal-search/portal-search-test com.liferay.portal.search.facet.faceted.searcher.test.AssetTagNamesFacetTest
test_run modules/apps/foundation/portal-search/portal-search-test com.liferay.portal.search.facet.faceted.searcher.test.FacetedSearcherTest
test_run modules/apps/foundation/portal-search/portal-search-test com.liferay.portal.search.facet.faceted.searcher.test.ModifiedFacetTest
test_run modules/apps/foundation/portal-search/portal-search-test com.liferay.portal.search.facet.faceted.searcher.test.ScopeFacetTest
test_run modules/apps/foundation/portal-search/portal-search-test com.liferay.portal.search.indexer.test.IndexerPostProcessorRegistryTest
test_run modules/apps/foundation/portal-search/portal-search-test com.liferay.portal.search.internal.test.SearchPermissionCheckerTest

test_run modules/apps/collaboration/bookmarks/bookmarks-test com.liferay.bookmarks.search.test.BookmarksEntrySearchTest 
test_run modules/apps/collaboration/bookmarks/bookmarks-test com.liferay.bookmarks.search.test.BookmarksFolderSearchTest

test_run modules/apps/forms-and-workflow/calendar/calendar-test com.liferay.calendar.search.test.CalendarSearcherTest

test_run modules/apps/collaboration/document-library/document-library-test com.liferay.document.library.search.test.DLFileEntrySearchTest

test_run modules/apps/forms-and-workflow/dynamic-data-lists/dynamic-data-lists-test com.liferay.dynamic.data.lists.search.test.DDLRecordSearchTest

test_run modules/apps/web-experience/journal/journal-test com.liferay.journal.asset.test.JournalArticleAssetSearchTest
test_run modules/apps/web-experience/journal/journal-test com.liferay.journal.search.test.JournalArticleIndexableTest
test_run modules/apps/web-experience/journal/journal-test com.liferay.journal.service.test.JournalArticleIndexVersionsTest
test_run modules/apps/web-experience/journal/journal-test com.liferay.journal.search.test.JournalArticleSearchTest
test_run modules/apps/web-experience/journal/journal-test com.liferay.journal.search.test.JournalFolderSearchTest
test_run modules/apps/web-experience/journal/journal-test com.liferay.journal.search.test.JournalIndexerTest

test_run modules/apps/collaboration/wiki/wiki-test com.liferay.wiki.search.test.WikiPageSearchTest
}

function run_some_tests()
{
	test_run modules/apps/foundation/portal-search/portal-search-test com.liferay.portal.search.journal.search.test.JournalArticleIndexerLocalizedContentTest
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

function test_run()
{
	subdir=$1
	tests=$2

	figlet -f mini test prepare $1 || true

	cd ${LIFERAY_PORTAL_DIR}/$subdir

	${LIFERAY_PORTAL_DIR}/gradlew testIntegration --tests $tests --stacktrace || { 
		RETURN_CODE=$?
		echo ${RETURN_CODE}
		echo "*** IGNORING BOGUS FAILURE & MOVING ON! :-)"
	}

	open build/reports/tests/testIntegration/index.html
}


main
