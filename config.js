module.exports = {
  server: {
    port: 3002,
    secret: "mygoals.72x$.secret"
  },
  db: [ 
    {   
        type: "sqlite3",
        options: {
            file: "data.db"
        }
    }
    /*
    host: "localhost",
    port: 3306,
    database: "mygoals",
    username: "dev",
    password: "dev123321"
    */
  ],

  path: {
      profiles: 'storage/profiles'
  },
  system: {
    profiles: {
        path: 'storage/profiles',
        format: 'jpg',
        width: 220,
        height: 220
    }
  }
}
