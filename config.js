module.exports = {
  server: {
    port: 3002,
    secret: "mygoals.72x$.secret"
  },
  db: {
    host: "localhost",
    port: 3306,
    database: "mygoals",
    username: "dev",
    password: "dev123321"
  },
  path: {
      profiles: 'storage/profiles'
  },
  system: {
    username: {
        min: 4,
        max: 32
    },
    password: {
      min: 6,
      max: 32
    },
    email: {
      max: 255
    },
    privileges: {
      admin: 99,
      guest: 0,
      user: 10
    }
  }
}
