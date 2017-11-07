package com.juxian.bosscomments.modules;


import com.juxian.bosscomments.models.PaymentResult;

public interface IPaymentHandler {
	void onPaymentCompleted(PaymentResult result);
}
