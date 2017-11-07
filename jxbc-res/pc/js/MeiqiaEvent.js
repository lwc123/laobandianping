(function(m, ei, q, i, a, j, s) {
	m[i] = m[i] || function() {
		(m[i].a = m[i].a || []).push(arguments)
	};
	j = ei.createElement(q),
		s = ei.getElementsByTagName(q)[0];
	j.async = true;
	j.charset = 'UTF-8';
	j.src = '//static.meiqia.com/dist/meiqia.js';
	s.parentNode.insertBefore(j, s);
})(window, document, 'script', '_MEIQIA');
_MEIQIA('entId', 47894);
_MEIQIA('withoutBtn');
function meiqiaclick() {
	_MEIQIA('showPanel', {
		groupToken: '8b6bd1c152e65ff57b0cc69076956960'
	});
}

function meiqiahide() {
	_MEIQIA('hidePanel');
}
$(document).ready(function() {
	$('#MeiqiaBtn').click(function() {
		meiqiaclick();
	});
	$('.MeiqiaCss').click(function() {
		meiqiaclick();
	});

});