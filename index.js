'use strict';
const path = require('path');
const execa = require('execa');

const bin = path.join(__dirname, 'do-not-disturb');

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

exports.isEnabled = async () => {
	const {stdout} = await execa(bin, ['status']);
	return stdout === 'on';
};
