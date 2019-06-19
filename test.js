import test from 'ava';
import doNotDisturb from '.';

let isEnabledInitially;

test.before(async () => {
	isEnabledInitially = await doNotDisturb.isEnabled();
});

test.after(async () => {
	await doNotDisturb.toggle(isEnabledInitially);
});

test('main', async t => {
	const isEnabled = await doNotDisturb.isEnabled();

	await doNotDisturb.toggle();
	t.not(isEnabled, await doNotDisturb.isEnabled());

	await doNotDisturb.disable();
	t.false(await doNotDisturb.isEnabled());

	await doNotDisturb.toggle(false);
	t.false(await doNotDisturb.isEnabled());

	await doNotDisturb.enable();
	t.true(await doNotDisturb.isEnabled());

	const beforeToggle = await doNotDisturb.isEnabled();
	const emitter = await doNotDisturb.startPolling(50);

	emitter.on('change', async value => {
		t.not(value, beforeToggle);
		t.is(value, await doNotDisturb.isEnabled());
	});

	await doNotDisturb.toggle();
	await new Promise(resolve => setTimeout(resolve, 100));
	await doNotDisturb.enable();
	t.true(await doNotDisturb.isEnabled());
});
