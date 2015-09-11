package com.liferay.portal.search.tck.dynamic.data.lists;

import org.arquillian.liferay.deploymentscenario.annotations.BndFile;

import com.liferay.portal.kernel.test.rule.Sync;
import com.liferay.portal.search.tck.bnd.BndConstants;

@BndFile(
		BndConstants.BASE_DIR 
		+ "/com/liferay/portal/search/tck/dynamic/data/lists"
		+ "/bnd.bnd")
@Sync
public class DDLRecordSearchTest 
	extends com.liferay.dynamic.data.lists.search.test.DDLRecordSearchTest {
	
}
