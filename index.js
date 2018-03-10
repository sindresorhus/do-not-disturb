'use strict';
const path = require('path');
const execa = require('execa');

const bin = path.join(__dirname, 'do-not-disturb');

exports.enable = () => {
	execa.sync(bin, ['on']);
};

exports.disable = () => {
	execa.sync(bin, ['off']);
};

exports.toggle = force => {
	if (force !== undefined) {
		execa.sync(bin, [force ? 'on' : 'off']);
	}

	execa.sync(bin, ['toggle']);
};

exports.isEnabled = () => execa.sync(bin, ['status']).stdout === 'on';
