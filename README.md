# Super-POM 超级POM项目

用于在项目上定义约束，以满足项目稳定、安全构建投产。
背景[使用Maven Enforcer Plugin提升构建稳定性](Maven-Enforcer.md)。
基于[Maven Enforcer Plugin](Maven-Enforcer.md)构建的约束规则。

1. 禁止引入冲突的依赖
2. 约束多模块项目
3. 其他经典约定：编码、运行时版本等
4. 依赖管理最佳实践(可选)

## 效果
```text
hujixudeMacBook-Pro:super-pom hujixu$ cd multi-module-demo/
hujixudeMacBook-Pro:multi-module-demo hujixu$ mvn compile
[INFO] Scanning for projects...
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Build Order:
[INFO] 
[INFO] multi-module-demo
[INFO] bad-child
[INFO] framework-bom
[INFO] bom-demo
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building multi-module-demo 1.0.1
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (default-enforcer) @ multi-module-demo ---
[WARNING] Rule 2: org.apache.maven.plugins.enforcer.ReactorModuleConvergence failed with message:
The reactor contains different versions.
[WARNING][Enforcer] 多模块项目子模块需要保持版本号相同（建议不要显式设置子模块版本号，从parent继承）
 --> com.youzan.i.hujixu:bad-child:jar:1.0.2

[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary:
[INFO] 
[INFO] multi-module-demo .................................. FAILURE [  0.725 s]
[INFO] bad-child .......................................... SKIPPED
[INFO] framework-bom ...................................... SKIPPED
[INFO] bom-demo ........................................... SKIPPED
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 0.911 s
[INFO] Finished at: 2018-07-03T15:52:20+08:00
[INFO] Final Memory: 8M/155M
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-enforcer-plugin:3.0.0-M2:enforce (default-enforcer) on project multi-module-demo: Some Enforcer rules have failed. Look above for specific messages explaining why the rule failed. -> [Help 1]
[ERROR] 
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR] 
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoExecutionException
```
查看全部违规
```text
[INFO] Scanning for projects...
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Build Order:
[INFO] 
[INFO] multi-module-demo
[INFO] bad-child
[INFO] framework-bom
[INFO] bom-demo
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building multi-module-demo 1.0.1
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (default-enforcer) @ multi-module-demo ---
[WARNING] Rule 2: org.apache.maven.plugins.enforcer.ReactorModuleConvergence failed with message:
The reactor contains different versions.
[WARNING][Enforcer] 多模块项目子模块需要保持版本号相同（建议不要显式设置子模块版本号，从parent继承）
 --> com.youzan.i.hujixu:bad-child:jar:1.0.2

[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (blacklist-struts-dependencies) @ multi-module-demo ---
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (force-guava-versions) @ multi-module-demo ---
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building bad-child 1.0.2
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (default-enforcer) @ bad-child ---
[WARNING] Rule 2: org.apache.maven.plugins.enforcer.ReactorModuleConvergence failed with message:
The reactor contains different versions.
[WARNING][Enforcer] 多模块项目子模块需要保持版本号相同（建议不要显式设置子模块版本号，从parent继承）
 --> com.youzan.i.hujixu:bad-child:jar:1.0.2

[WARNING] Rule 3: org.apache.maven.plugins.enforcer.EvaluateBeanshell failed with message:
[WARNING][Enforcer] 请使用utf-8编码:<encoding>utf-8<encoding>
[WARNING] Rule 4: org.apache.maven.plugins.enforcer.EvaluateBeanshell failed with message:
[WARNING][Enforcer] 请不要单独配置<file.encoding>，只需要配置<encoding>utf-8<encoding>
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (blacklist-struts-dependencies) @ bad-child ---
[WARNING] Rule 0: org.apache.maven.plugins.enforcer.BannedDependencies failed with message:
[WARNING][Enforcer] Struts [2.1.1,2.5.14.1] is banned for security issue https://cwiki.apache.org/confluence/display/WW/S2-056
Found Banned Dependency: org.apache.struts:struts2-core:jar:2.5.14.1
Use 'mvn dependency:tree' to locate the source of the banned dependencies.
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (force-guava-versions) @ bad-child ---
[WARNING] Rule 0: org.apache.maven.plugins.enforcer.BannedDependencies failed with message:
[WARNING][Enforcer] Only Guava 19.0 allowed
Found Banned Dependency: com.google.guava:guava:jar:18.0
Use 'mvn dependency:tree' to locate the source of the banned dependencies.
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ bad-child ---
[INFO] Using 'gbk' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ bad-child ---
[INFO] Nothing to compile - all classes are up to date
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building framework-bom 1.0.1
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (default-enforcer) @ framework-bom ---
[WARNING] Rule 2: org.apache.maven.plugins.enforcer.ReactorModuleConvergence failed with message:
The reactor contains different versions.
[WARNING][Enforcer] 多模块项目子模块需要保持版本号相同（建议不要显式设置子模块版本号，从parent继承）
 --> com.youzan.i.hujixu:bad-child:jar:1.0.2

[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (blacklist-struts-dependencies) @ framework-bom ---
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (force-guava-versions) @ framework-bom ---
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building bom-demo 1.0.1
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (default-enforcer) @ bom-demo ---
[WARNING] 
Dependency convergence error for org.slf4j:slf4j-api:1.7.21 paths to dependency are:
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-org.slf4j:slf4j-api:1.7.21
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-org.slf4j:jul-to-slf4j:1.7.21
        +-org.slf4j:slf4j-api:1.7.21
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-org.slf4j:jcl-over-slf4j:1.7.21
        +-org.slf4j:slf4j-api:1.7.21
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-org.slf4j:slf4j-api:1.7.6
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-org.apache.curator:curator-framework:2.8.0
      +-org.apache.curator:curator-client:2.8.0
        +-org.slf4j:slf4j-api:1.7.6
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-org.apache.curator:curator-framework:2.8.0
      +-org.apache.zookeeper:zookeeper:3.4.6
        +-org.slf4j:slf4j-api:1.6.1

[WARNING] 
Dependency convergence error for com.google.guava:guava:23.6-android paths to dependency are:
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.google.guava:guava:23.6-android
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-org.apache.curator:curator-framework:2.8.0
      +-org.apache.curator:curator-client:2.8.0
        +-com.google.guava:guava:16.0.1
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-org.apache.curator:curator-framework:2.8.0
      +-com.google.guava:guava:16.0.1
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-org.apache.curator:curator-recipes:2.8.0
      +-com.google.guava:guava:16.0.1

[WARNING] 
Dependency convergence error for org.apache.httpcomponents:httpcore:4.4.4 paths to dependency are:
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-org.apache.httpcomponents:httpclient:4.5.2
          +-org.apache.httpcomponents:httpcore:4.4.4
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-org.apache.httpcomponents:httpcore:4.4.5
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-org.apache.httpcomponents:httpcore-nio:4.4.5
          +-org.apache.httpcomponents:httpcore:4.4.5
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-com.youzan:httpasyncclient:4.1.2-RELEASE
          +-org.apache.httpcomponents:httpcore:4.4.5

[WARNING] 
Dependency convergence error for org.slf4j:jul-to-slf4j:1.7.21 paths to dependency are:
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-org.slf4j:jul-to-slf4j:1.7.21
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-org.slf4j:jul-to-slf4j:1.7.6

[WARNING] 
Dependency convergence error for commons-logging:commons-logging:1.2 paths to dependency are:
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-org.apache.httpcomponents:httpclient:4.5.2
          +-commons-logging:commons-logging:1.2
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-com.youzan:httpasyncclient:4.1.2-RELEASE
          +-commons-logging:commons-logging:1.2
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-commons-validator:commons-validator:1.5.1
          +-commons-beanutils:commons-beanutils:1.9.2
            +-commons-logging:commons-logging:1.1.1
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-commons-validator:commons-validator:1.5.1
          +-commons-logging:commons-logging:1.2

[WARNING] 
Dependency convergence error for com.fasterxml.jackson.core:jackson-databind:2.8.9 paths to dependency are:
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.fasterxml.jackson.core:jackson-databind:2.8.9
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-com.fasterxml.jackson.core:jackson-databind:2.7.9.1

[WARNING] 
Dependency convergence error for org.slf4j:jcl-over-slf4j:1.7.21 paths to dependency are:
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-org.slf4j:jcl-over-slf4j:1.7.21
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-org.slf4j:jcl-over-slf4j:1.7.6

[WARNING] 
Dependency convergence error for commons-collections:commons-collections:3.2.1 paths to dependency are:
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-commons-validator:commons-validator:1.5.1
          +-commons-beanutils:commons-beanutils:1.9.2
            +-commons-collections:commons-collections:3.2.1
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-commons-validator:commons-validator:1.5.1
          +-commons-collections:commons-collections:3.2.2

[WARNING] Rule 1: org.apache.maven.plugins.enforcer.DependencyConvergence failed with message:
Failed while enforcing releasability. See above detailed error message.
[WARNING] Rule 2: org.apache.maven.plugins.enforcer.ReactorModuleConvergence failed with message:
The reactor contains different versions.
[WARNING][Enforcer] 多模块项目子模块需要保持版本号相同（建议不要显式设置子模块版本号，从parent继承）
 --> com.youzan.i.hujixu:bad-child:jar:1.0.2

[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (blacklist-struts-dependencies) @ bom-demo ---
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (force-guava-versions) @ bom-demo ---
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ bom-demo ---
[INFO] Using 'utf-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ bom-demo ---
[INFO] Nothing to compile - all classes are up to date
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary:
[INFO] 
[INFO] multi-module-demo .................................. SUCCESS [  0.673 s]
[INFO] bad-child .......................................... SUCCESS [  1.086 s]
[INFO] framework-bom ...................................... SUCCESS [  0.011 s]
[INFO] bom-demo ........................................... SUCCESS [  1.031 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 2.982 s
[INFO] Finished at: 2018-07-03T15:55:10+08:00
[INFO] Final Memory: 13M/225M
[INFO] ------------------------------------------------------------------------
```
