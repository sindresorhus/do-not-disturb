import test from 'ava';
import delay from 'delay';
import m from '.';

let isEnabledInitially;

test.before(() => {
	isEnabledInitially = m.isEnabled();
});

test.after(() => {
	m.toggle(isEnabledInitially);
});

const stepDelay = () => delay(process.env.CI ? 10000 : 2000);

test('main', async t => {
	await stepDelay();
	const isEnabled = m.isEnabled();
	await stepDelay();

	m.toggle();
	await stepDelay();
	t.not(isEnabled, m.isEnabled());
	await stepDelay();

	m.disable();
	await stepDelay();
	t.false(m.isEnabled());
	await stepDelay();

	m.toggle(false);
	await stepDelay();
	t.false(m.isEnabled());
	await stepDelay();

	m.enable();
	await stepDelay();
	t.true(m.isEnabled());
	await stepDelay();
});
