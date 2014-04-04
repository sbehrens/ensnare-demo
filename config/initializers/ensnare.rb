# log_only configuration file
AppTrap.setup do |config|

  # Config type
  config.type = :custom

  # Settings to configure the operation mode of config.
  # Disable Ensnare from running.
  config.mode = :log

  #config.dashboard_user_method = :current_user
  #config.dashboard_authorization_method = :admin?
  # Log violation counts for both user account and IP address that triggers the trap
  config.trap_on = [:ip, :user, :session]
  #
   config.current_user_method = :current_user
  config.global_timer = 1200
  # Identify authorized dashboard users
  config.dashboard_user_method = :current_user
  config.dashboard_authorization_method = :admin?
  require 'securerandom'
  config.randomizer = SecureRandom.hex

  config.enabled_traps = [

    {:type=>:cookie,
     :options=>{
        # Specify an array of cookie names and their values you would like to use for your application.
        # If no cookie names are specified, you can select some predefined cookies with the next setting.
        :cookie_names=>{:ac_mon => config.randomizer},
        # Select a predefined selection of cookie names.
        # :admin => this sets a cookie named admin with a boolean value set to false
        # :debug => this sets a cookie named debug with a boolean value set to false
        # :random => this generates a random N character cookie with a random encrypted value
        # :google => this generates 4 random cookies that look like Google tracking
        # :uid => this sets a cookie that look like a UID
        # :gid => this sets a cookie that looks like a GID
        :predefined_cookies=>[:google, :random]
     }
     },
    {:type=>:parameter,
     :options=>{
        # Specify an array of parameter names and their values you would like to use for your application.
        # If no parameter names are specified, you can select some predefined parameters with the next setting.
        # Notice how the config.randomizer function is passed in here, this makes the parameter value non static
        :parameter_names=>{:u_track => config.randomizer},
        # Select a predefined selection of parameter names.
        # :admin => this sets a cookie named admin with a boolean value set to false
        # :debug => this sets a cookie named debug with a boolean value set to false
        # :random => this cookie generates a random 32 character cookie with a random encrypted-looking value
        # :uid => this sets a cookie that look like a UID
        # :gid => this sets a cookie that looks like a GID
        :predefined_parameters=>[:random]
     }
     },
    {:type=>:routing_error,
     :options=>{
      # Specify a list of paths to trigger traps on.  Very useful for detecting directory busting attacks
       :bad_paths=>["/admin", "/debug", "/robots", "/destory"],
       # Each trap has a weight of 10.  Instead of only resulting in one violation, this will count as 10!
       :violation_weight=>10
     }
     },
  ]

config.thresholds = []
  config.thresholds << {:timer=>120, :trap_count=>1,
                        :traps=>[
                          {:trap=>"message",:weight=>100,:content=>"stop it!"}
                          # {:trap=>"captcha", :persist=>true },
                          #{:trap=>"redirect_loop",:weight=>40,:url=>"/"},
                          #{:trap=>"throttle",:weight=>20,:min_delay=>7,:max_delay=>12},
                          #{:trap=>"not_found",:weight=>20},
                          #{:trap=>"none", :weight=>20}
  ]}
    config.thresholds << {:timer=>600, :trap_count=>5,
                        :traps=>[
                          # {:trap=>"message",:weight=>100,:content=>"stop it!"}
                          # {:trap=>"captcha", :persist=>true },
                          {:trap=>"redirect",:weight=>10,:url=>"/"},
                          # {:trap=>"throttle",:weight=>100,:min_delay=>60,:max_delay=>90}
                          {:trap=>"not_found",:weight=>20},
                          {:trap=>"server_error", :weight=>20},
                          {:trap=>"redirect_loop",:weight=>5, :parameter=>'test'},
                          {:trap=>"random_content",:weight=>25,:min_size=>500,:max_size=>1500},
                          {:trap=>"none", :weight=>20}
  ]}
    config.thresholds << {:timer=>900, :trap_count=>15,
                        :traps=>[
                          # {:trap=>"message",:weight=>100,:content=>"stop it!"}
                          # {:trap=>"captcha", :persist=>true },
                          {:trap=>"throttle",:weight=>40,:min_delay=>5,:max_delay=>45},
                          {:trap=>"server_error", :weight=>20},
                          {:trap=>"random_content",:weight=>25,:min_size=>500,:max_size=>2900},
                          {:trap=>"none", :weight=>15}
  ]}
end
module AppTrap
  module CustomMethods

    def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

  end
end

ActionController::Base.class_eval do
  include AppTrap::CustomMethods
end
