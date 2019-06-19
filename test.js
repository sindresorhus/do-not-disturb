import test from 'ava';
import m from '.';

let isEnabledInitially;

test.before(async () => {
	isEnabledInitially = await m.isEnabled();
});

test.after(async () => {
	await m.toggle(isEnabledInitially);
});

test('main', async t => {
	const isEnabled = await m.isEnabled();

	await m.toggle();
	t.not(isEnabled, await m.isEnabled());

	await m.disable();
	t.false(await m.isEnabled());

	await m.toggle(false);
	t.false(await m.isEnabled());

	await m.enable();
	t.true(await m.isEnabled());

	const beforeToggle = await m.isEnabled();
	const emitter = await m.startPolling(50);

	emitter.on('change', async value => {
		t.not(value, beforeToggle);
		t.is(value, await m.isEnabled());
	});

	await m.toggle();
	await new Promise(resolve => setTimeout(resolve, 100));
});
