'use strict';
const path = require('path');
const execa = require('execa');
const electronUtil = require('electron-util/node');
const fkill = require('fkill');

const bin = path.join(electronUtil.fixPathForAsarUnpack(__dirname), 'do-not-disturb');

exports.enable = async () => {
	await execa.sync(bin, ['on']);
  await fkill('NotificationCenter');
};

exports.disable = async () => {
	await execa(bin, ['off']);
  await fkill('NotificationCenter');
};

exports.toggle = async force => {
	if (force !== undefined) {
		await execa(bin, [force ? 'on' : 'off']);
    await fkill('NotificationCenter');
		return;
	}

	await execa(bin, ['toggle']);
  await fkill('NotificationCenter');
};

exports.isEnabled = async () => {
	const {stdout} = await execa(bin, ['status']);
	return stdout === 'on';
};
