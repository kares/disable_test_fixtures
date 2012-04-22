
ActiveRecord::Base.configurations = { 'test' => {
    'adapter' => 'mysql',
    'host' => 'localhost',
    'database' => 'disable_test_fixtures',
    'username' => 'root'
}} # when configurations are empty fixtures are not setup !
