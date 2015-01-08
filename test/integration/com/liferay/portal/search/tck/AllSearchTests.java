/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.portal.search.tck;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

/**
 * @author André de Oliveira
 */
@RunWith(Suite.class)
@SuiteClasses( {
	com.liferay.portlet.asset.search.AssetCategorySearchTest.class,
	com.liferay.portlet.asset.search.AssetVocabularySearchTest.class,
	com.liferay.portlet.blogs.asset.BlogsEntryAssetSearchTest.class,
	com.liferay.portlet.blogs.search.BlogsEntrySearchTest.class,
	com.liferay.portlet.bookmarks.search.BookmarksEntrySearchTest.class,
	com.liferay.portlet.bookmarks.search.BookmarksFolderSearchTest.class,
	com.liferay.portlet.documentlibrary.search.DLFileEntrySearchTest.class,
	com.liferay.portlet.documentlibrary.search.DLFolderSearchTest.class,
	com.liferay.portlet.dynamicdatalists.service.DDLRecordServiceTest.class,
	com.liferay.portlet.journal.asset.JournalArticleAssetSearchTest.class,
	com.liferay.portlet.journal.search.JournalArticleSearchTest.class,
	com.liferay.portlet.journal.search.JournalFolderSearchTest.class,
	com.liferay.portlet.messageboards.search.MBMessageSearchTest.class,
	com.liferay.portlet.wiki.search.WikiPageSearchTest.class
})
public class AllSearchTests {

}