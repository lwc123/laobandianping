package net.juxian.appgenome.upgrade;


import net.juxian.appgenome.models.PackageVersion;

public interface IPackageRepository {	
	PackageVersion getLastVersion();
}
