@Suppress("JcenterRepositoryObsolete") dependencyResolutionManagement {
  repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
  repositories {
    google()
    mavenCentral()
    maven(url = "https://oss.sonatype.org/content/groups/public")
    jcenter() // Warning: this repository is going to shut down soon
  }
}
include(":app")
