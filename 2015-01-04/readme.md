# DB Backup Script

Making a MySql Database backup using ruby:

* Do a complete dump of any MySQL database
* Name the backup file based on the date of the backup
* Allow the creation of our “end-of-iteration” backup, using a different
naming scheme
* Compress the backup files
* Delete backups from completed iterations

## How to run

#### Taking a backup of the database:

```
$ ruby db-backup.rb db_name
```

#### Taking a backup of the database and adding iteration name

```
$ ruby db-backup.rb db_name iteration_name
```

## Interesting Reading

* [Build Awesome Command-Line Applications in Ruby 2: Control Your Computer, Simplify Your Life](http://www.amazon.com/Build-Awesome-Command-Line-Applications-Ruby/dp/1937785750)

