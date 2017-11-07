package com.juxian.bosscomments.repositories;

import com.android.volley.Response;

import net.juxian.appgenome.models.PackageVersion;
import net.juxian.appgenome.upgrade.IPackageRepository;
import net.juxian.appgenome.webapi.WebApiClient;

public class PackageRepository implements IPackageRepository {

	@Override
	public PackageVersion getLastVersion() {
		Response<?> responseResult = WebApiClient.getSingleton().httpGet(ApiEnvironment.Upgrade_GetLastVersion_Endpoint, PackageVersion.class);
		if (responseResult.isSuccess()) {
			PackageVersion result = (PackageVersion) responseResult.result;
			return result;
		} else {
			return null;
		}
	}
}
