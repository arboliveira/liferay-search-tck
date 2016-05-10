package com.liferay.portal.search.tck.dynamic.data.lists;

import org.arquillian.liferay.deploymentscenario.annotations.BndFile;
import org.junit.ClassRule;
import org.junit.Rule;
import org.junit.runner.RunWith;

import com.liferay.arquillian.extension.junit.bridge.junit.Arquillian;
import com.liferay.portal.kernel.test.rule.AggregateTestRule;
import com.liferay.portal.kernel.test.rule.Sync;
import com.liferay.portal.kernel.test.rule.SynchronousDestinationTestRule;
import com.liferay.portal.search.tck.bnd.BndConstants;
import com.liferay.portal.test.rule.LiferayIntegrationTestRule;

@BndFile(
		BndConstants.BASE_DIR
		+ "/com/liferay/portal/search/tck/dynamic/data/lists"
		+ "/bnd.bnd")
@RunWith(Arquillian.class)
@Sync
public class DDLRecordSearchTest
	extends com.liferay.dynamic.data.lists.search.test.DDLRecordSearchTest {

	@ClassRule
	@Rule
	public static final AggregateTestRule aggregateTestRule =
		new AggregateTestRule(
			new LiferayIntegrationTestRule(),
			SynchronousDestinationTestRule.INSTANCE);

}
