/**
 * Created by demeter on 2022. 08. 08..
 */

@IsTest
private class GaborClassTest {
	@IsTest
	static void testBehavior() {
		String user = 'Gabor';
		String result = GaborClass.greetUser(user);
		System.assertEquals('Hello ' + user, result);
	}
}