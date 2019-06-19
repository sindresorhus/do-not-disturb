'use strict';
const path = require('path');
const {EventEmitter} = require('events');
const execa = require('execa');
const electronUtil = require('electron-util/node');

const bin = path.join(electronUtil.fixPathForAsarUnpack(__dirname), 'do-not-disturb');

const isEnabled = async () => {
	const {stdout} = await execa(bin, ['status']);
	return stdout === 'on';
};

let pollingInterval;

exports.stopPolling = () => clearInterval(pollingInterval);

exports.startPolling = async (milliseconds = 3000) => {
	exports.stopPolling();

	const emitter = new EventEmitter();
	let currentValue = await isEnabled();

	pollingInterval = setInterval(async () => {
		const newValue = await isEnabled();

		if (newValue !== currentValue) {
			currentValue = newValue;
			emitter.emit('change', newValue);
		}
	}, milliseconds);

	return emitter;
};

exports.enable = async () => {
	await execa.sync(bin, ['on']);
};

exports.disable = async () => {
	await execa(bin, ['off']);
};

exports.toggle = async force => {
	if (force !== undefined) {
		await execa(bin, [force ? 'on' : 'off']);
		return;
	}

	await execa(bin, ['toggle']);
};

exports.isEnabled = isEnabled;
