package com.example.myapp;

import android.app.Application;
import com.facebook.react.PackageList;
import com.facebook.react.ReactApplication;
import com.facebook.react.ReactHost;
import com.facebook.react.ReactNativeApplicationEntryPoint;
import com.facebook.react.ReactPackage;
import com.facebook.react.common.build.ReactBuildConfig;
import com.facebook.react.defaults.DefaultReactHost;
import java.util.Collections;
import java.util.List;

public class MainApplication extends Application implements ReactApplication {

  private ReactHost reactHost;

  @Override
  public ReactHost getReactHost() {
    if (reactHost == null) {
      List<ReactPackage> packages = new PackageList(this).getPackages();
      // Packages that cannot be autolinked yet can be added manually here, for example:
      // packages.add(new MyReactNativePackage());

      // Kotlin default arguments are not available from Java, so every argument is passed.
      reactHost =
          DefaultReactHost.getDefaultReactHost(
              getApplicationContext(),
              packages,
              "index", // jsMainModulePath
              "index.android.bundle", // jsBundleAssetPath
              null, // jsBundleFilePath
              null, // jsRuntimeFactory (Hermes by default)
              ReactBuildConfig.DEBUG, // useDevSupport
              Collections.emptyList(), // cxxReactPackageProviders
              exception -> {
                if (exception instanceof RuntimeException) {
                  throw (RuntimeException) exception;
                }
                throw new RuntimeException(exception);
              },
              null); // bindingsInstaller
    }
    return reactHost;
  }

  @Override
  public void onCreate() {
    super.onCreate();
    ReactNativeApplicationEntryPoint.loadReactNative(this);
  }
}
