environments {
  production {
    dataSource {
      dbCreate = "update"
      driverClassName = "org.postgresql.Driver"
      dialect = org.hibernate.dialect.PostgreSQLDialect
      uri = new URI(System.env.DATABASE_URL?:"postgres://localhost:5432/test")
      url = "jdbc:postgresql://" + uri.host + ":" + uri.port + uri.path + "?sslmode=require"
      username = uri.userInfo.split(":")[0]
      password = uri.userInfo.split(":")[1]
    }
  }
}
