(function( factory ) {
	if ( typeof define === "function" && define.amd ) {
		define( ["jquery", "../jquery.validate"], factory );
	} else {
		factory( jQuery );
	}
}(function( $ ) {

/*
 * Translated default messages for the jQuery validation plugin.
 * Locale: ZH (Chinese, ���� (Zh��ngw��n), ����, �h�Z)
 */
$.extend($.validator.messages, {
	required: "���Ǳ����ֶ�",
	remote: "���������ֶ�",
	email: "��������Ч�ĵ����ʼ���ַ",
	url: "��������Ч����ַ",
	date: "��������Ч������",
	dateISO: "��������Ч������ (YYYY-MM-DD)",
	number: "��������Ч������",
	digits: "ֻ����������",
	creditcard: "��������Ч�����ÿ�����",
	equalTo: "������벻��ͬ",
	extension: "��������Ч�ĺ�׺",
	maxlength: $.validator.format("���������� {0} ���ַ�"),
	minlength: $.validator.format("����Ҫ���� {0} ���ַ�"),
	rangelength: $.validator.format("�����볤���� {0} �� {1} ֮����ַ���"),
	range: $.validator.format("�����뷶Χ�� {0} �� {1} ֮�����ֵ"),
	max: $.validator.format("�����벻���� {0} ����ֵ"),
	min: $.validator.format("�����벻С�� {0} ����ֵ")
});

}));