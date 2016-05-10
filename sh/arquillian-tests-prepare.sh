#!/bin/sh

set -o errexit ; set -o nounset



function ant_deploy()
{
	subdir=$1

	figlet -f mini ant deploy $1 

	cd ${LIFERAY_PORTAL_DIR}/$subdir
	ant deploy install-portal-snapshot
}

function gradle_deploy()
{
	subdir=$1

	figlet -f mini gradle deploy $1 

	cd ${LIFERAY_PORTAL_DIR}/$subdir
	${LIFERAY_PORTAL_DIR}/gradlew deploy
}

function test_prepare()
{
	subdir=$1
	tests=$2

	figlet -f mini test prepare $1 

	cd ${LIFERAY_PORTAL_DIR}/$subdir
	${LIFERAY_PORTAL_DIR}/gradlew testIntegration --tests $tests || { 
		RETURN_CODE=$?
		echo ${RETURN_CODE}
		echo "*** IGNORING BOGUS FAILURE & MOVING ON! :-)"
	}
}


ant_deploy portal-kernel
ant_deploy portal-test
ant_deploy portal-test-integration

gradle_deploy modules/apps/forms-and-workflow/dynamic-data-mapping/dynamic-data-mapping-test-util

test_prepare modules/apps/foundation/portal-search/portal-search-test com.liferay.portal.search.facet.faceted.searcher.test.FacetedSearcherTest.testSearchByKeywords

test_prepare modules/apps/collaboration/bookmarks/bookmarks-test com.liferay.bookmarks.search.test.BookmarksEntrySearchTest.testSearchBaseModel
test_prepare modules/apps/collaboration/document-library/document-library-test com.liferay.document.library.search.test.DLFileEntrySearchTest.testOrderByDDMTextField
test_prepare modules/apps/collaboration/wiki/wiki-test com.liferay.wiki.search.test.WikiPageSearchTest.testSpecificFields
test_prepare modules/apps/forms-and-workflow/calendar/calendar-test com.liferay.calendar.search.test.CalendarSearcherTest.testBasicSearchWithOneTerm
test_prepare modules/apps/forms-and-workflow/dynamic-data-lists/dynamic-data-lists-test com.liferay.dynamic.data.lists.search.test.DDLRecordSearchTest.testBasicSearchWithJustOneTerm
test_prepare modules/apps/web-experience/journal/journal-test com.liferay.journal.search.test.JournalArticleSearchTest.testOrderByDDMTextField
