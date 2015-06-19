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
	com.liferay.portal.search.tck.bookmarks.BookmarksEntrySearchTest.class,
	com.liferay.portal.search.tck.bookmarks.BookmarksFolderSearchTest.class,
	com.liferay.portal.search.tck.dynamic.data.lists.DDLRecordSearchTest.class,
	com.liferay.portal.search.tck.wiki.WikiPageSearchTest.class
})
public class AllSearchTestsArquillian {

}