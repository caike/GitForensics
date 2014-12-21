# Git Forensics

**NOTICE: WIP, alpha, highly experimental**

This tool helps you track the relationships between files inside of your Git  
repository. If you often modify several files together, it will tell you so.  

*Why is this useful?*

Because it will often prevent you from breaking an interdependence between files
that you might not be aware of.

This means when you have to make a change in your application, Git Forensics can help you
identify what other files need to be updated, like tests, configuration files
and others.

## Installing / Using

* Make sure you have SQLite3 installed.  
* Run `bundle`
* Run `./bin/setup` to create the necessary database tables.
* Run `./bin/import <project-path>` to import the Git history for a project

Finally, in order to print a list of files associated with a specific file, run:  

`./bin/search <name-of-file>`

The output is a list of files frequently committed with the file in question.

For example:

```
$ ./bin/search spec/models/artist_spec.rb

88%       	app/models/artist.rb
62%       	db/schema.rb
50%       	config/routes.rb
38%       	config/environments/development.rb
38%       	app/views/devise/sessions/new.html.erb
38%       	config/initializers/devise.rb
38%       	config/locales/pt.yml
25%       	db/migrate/20111026020248_create_artists.rb
```

This means if you've just joined this example project and you need to edit `app/models/artist_spec.rb`, then `app/models/artist.rb` might need to be
changed as well.

## Limitations

Does not work yet for projects with a long Git history :(

## Contributors

* Carlos Souza
* Olivier Lacan
