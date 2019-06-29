import test from 'ava';
import delay from 'delay';
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

	const listener = async value => {
		t.not(value, beforeToggle);
		t.is(value, await doNotDisturb.isEnabled());
	};

	doNotDisturb.on('change', listener, {
		pollInterval: 50
	});

	await doNotDisturb.toggle();
	await delay(100);

	doNotDisturb.off('change', listener);

	doNotDisturb.on('change', value => {
		t.is(true, value);
	});

	await doNotDisturb.toggle();
	await delay(100);
});
