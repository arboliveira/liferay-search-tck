package com.liferay.portal.search.tck.wiki;

import org.arquillian.liferay.deploymentscenario.annotations.BndFile;

import com.liferay.portal.kernel.test.rule.Sync;
import com.liferay.portal.search.tck.bnd.BndConstants;

@BndFile(
		BndConstants.BASE_DIR 
		+ "/com/liferay/portal/search/tck/wiki"
		+ "/bnd.bnd")
@Sync
public class WikiPageSearchTest extends
		com.liferay.wiki.search.test.WikiPageSearchTest {

}
