
ActiveRecord::Base.configurations = { 'test' => {
    'adapter' => 'sqlite3', 'database' => ':memory:'
}} # when configurations are empty fixtures are not setup !
