#!/bin/sh

set -o errexit ; set -o nounset



function ant_deploy()
{
	subdir=$1
	cd ${LIFERAY_PORTAL_DIR}/$subdir
	ant deploy install-portal-snapshot
}

function gradle_deploy()
{
	subdir=$1
	cd ${LIFERAY_PORTAL_DIR}/$subdir
	${LIFERAY_PORTAL_DIR}/gradlew deploy
}

function test_prepare()
{
	subdir=$1
	tests=$2
	cd ${LIFERAY_PORTAL_DIR}/$subdir
	${LIFERAY_PORTAL_DIR}/gradlew testIntegration --tests $tests || { 
		RETURN_CODE=$?
		echo ${RETURN_CODE}
		echo "*** IGNORING BOGUS FAILURE & MOVING ON! :-)"
	}
}


ant_deploy portal-service
ant_deploy portal-test
ant_deploy portal-test-internal

gradle_deploy modules/apps/dynamic-data-mapping/dynamic-data-mapping-test-util

test_prepare modules/apps/bookmarks/bookmarks-test com.liferay.bookmarks.search.test.BookmarksEntrySearchTest.testSearchBaseModel
test_prepare modules/apps/calendar/calendar-test com.liferay.calendar.search.test.CalendarSearcherTest.testBasicSearchWithOneTerm
test_prepare modules/apps/document-library/document-library-test com.liferay.document.library.search.test.DLFileEntrySearchTest.testOrderByDDMTextField
test_prepare modules/apps/dynamic-data-lists/dynamic-data-lists-test com.liferay.dynamic.data.lists.search.test.DDLRecordSearchTest.testBasicSearchWithJustOneTerm
test_prepare modules/apps/journal/journal-test com.liferay.journal.search.test.JournalArticleSearchTest.testOrderByDDMTextField
test_prepare modules/apps/wiki/wiki-test com.liferay.wiki.search.test.WikiPageSearchTest.testSpecificFields
