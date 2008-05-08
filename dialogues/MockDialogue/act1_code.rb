  ## Snippet 1
  class ReportPrinter
    ...
    def start(user, password)
      @token = @login_service.login(username, password)
      fail "Unable to start Report Printer" if @token.nil?
    end
    ...
  end

  ## Snippet 2
  def initialize
    @login_service = LoginService.new
  end
  
  ## Snippet 3
  def print_report
    if @login_service.allowed?(@token, 'print')
      generate_report
      send_report_to_printer
    else
      fail "You are not authorized to use the printer"
    end
  end
  
  ## Snippet 4
  def initialize(login_service)
    @login_service = login_service
  end
  
  # Snippet 5
  def test_good_login
    login_service = FakeLoginService.new
    printer = ReportPrinter.new(login_service)
    printer.start("USER", "PASSWORD")
    ...
  end
  
  ## Snippet 5a
  class FakeLoginService
    def login(user, password)
      "fake_security_token"
    end
    def allow?(token)
      true
    end
  end
  
  ## Snippet 6
  class FakeLoginService
    def login(user, password)
      (password == "PASSWORD") ? "fake_security_token" : nil
    end
  end
  
  ## Snippet 7
  class FakeLoginService
    def login(user, password)
      nil
    end
  end
  
  ## Snippet 8
  def test_bad_login
    login_service = FakeLoginServiceWithFailingLogin.new
    printer = ReportPrinter.new(login_service)
    assert_raise LoginError do
      printer.start("USER", "PASSWORD")
    end
  end
  
  ## Snippet 9
  class FakeLoginService
    def new(&login_behavior)
      @login_behavior = login_behavior
    end
    def login(user, password)
      @login_behavior.call(user, password)
    end
  end
  
  
  # Snippet 10
  login_service = FakeLoginService.new { "fake_security_token" }
  
  
  ## Snippet 11
  login_service = FakeLoginService.new { nil }
  
  
  ## Snippet 12
  def test_good_login
    login_service = FakeLoginService.new { "fake_security_token" }
    printer = ReportPrinter.new(login_service)
    printer.start("USER", "PASSWORD")
    ...
  end
  
  ## Snippet 13
  def test_good_login
    login_service = flexmock('mock_service')
    ...
  end
  
  ## Snippet 14
  def test_good_login
    login_service = flexmock('mock_service')
    login_serivce.should_receive(:login).and_return('fake_security_token')
    ...
  end
  
  ## Snippet 15
  def test_good_login
    login_service = flexmock('mock_service')
    login_serivce.should_receive(:login).and_return('fake_security_token').once
    ...
  end
  
  ## Snippet 16
  def test_username_and_password_are_passed_along
    login_service = flexmock('mock_service')
    login_serivce.should_receive(:login).with('joe', 'ICEICEBABY').
      and_return('fake_security_token').once
    printer = ReportPrinter.new(login_service)
    printer.start("joe", "ICEICEBABY")
    ...        
  end    
  
  ## Snippet 17
  def test_username_and_password_are_passed_along
    username, password = 'username', 'password'
    login_service = flexmock('mock_service')
    login_serivce.should_receive(:login).with(username, password).
      and_return('fake_security_token').once
    printer = ReportPrinter.new(login_service)
    printer.start(username, password)
    ...        
  end    
  
