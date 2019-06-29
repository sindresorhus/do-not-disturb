'use strict';
const path = require('path');
const EventEmitter = require('events');
const execa = require('execa');
const electronUtil = require('electron-util/node');

const binary = path.join(electronUtil.fixPathForAsarUnpack(__dirname), 'do-not-disturb');

const isEnabled = async () => {
	const {stdout} = await execa(binary, ['status']);
	return stdout === 'on';
};

let emitter;

const createEmitter = (pollInterval = 3000) => {
	if (emitter) {
		return emitter;
	}

	emitter = new EventEmitter();

	emitter.once('newListener', async event => {
		if (event === 'change') {
			let currentValue = await isEnabled();

			const pollingInterval = setInterval(async () => {
				if (emitter.listenerCount('change') === 0) {
					clearInterval(pollingInterval);
					return;
				}

				const nextValue = await isEnabled();

				if (nextValue !== currentValue) {
					currentValue = nextValue;
					emitter.emit('change', nextValue);
				}
			}, pollInterval);
		}
	});

	return emitter;
};

exports.on = (eventName, listener, options = {}) =>
	createEmitter(options.pollInterval).on(eventName, listener);

exports.off = (eventName, listener, options = {}) =>
	createEmitter(options.pollInterval).off(eventName, listener);

exports.enable = async () => {
	await execa.sync(binary, ['on']);
};

exports.disable = async () => {
	await execa(binary, ['off']);
};

exports.toggle = async force => {
	if (force !== undefined) {
		await execa(binary, [force ? 'on' : 'off']);
		return;
	}

	await execa(binary, ['toggle']);
};

exports.isEnabled = isEnabled;
