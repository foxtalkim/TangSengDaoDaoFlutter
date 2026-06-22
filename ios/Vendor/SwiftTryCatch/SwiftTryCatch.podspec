Pod::Spec.new do |s|
  s.name          = 'SwiftTryCatch'
  s.version       = '0.0.1'
  s.summary       = 'Vendored bridge for Swift try/catch'
  s.description   = <<-DESC
    Vendored SwiftTryCatch source providing both the 2-arg
    `try:catch:` form (used by flutter_dynamic_icon_plus) and the
    3-arg `try:catch:finally:` form. Replaces the upstream
    `cfr/SwiftTryCatch` repo (now 404 on GitHub) and the partial
    `williamFalcon/SwiftTryCatch` master (missing the 2-arg form).
  DESC
  s.license       = { :type => 'MIT' }
  s.homepage      = 'https://github.com/williamFalcon/SwiftTryCatch'
  s.author        = { 'William Falcon' => 'waf2107@columbia.edu' }
  s.platform      = :ios, '12.0'
  s.source        = { :path => '.' }
  s.source_files  = 'SwiftTryCatch.{h,m}'
  s.public_header_files = 'SwiftTryCatch.h'
  s.requires_arc  = true
end
