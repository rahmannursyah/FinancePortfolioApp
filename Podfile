# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!

workspace 'FinancePortfolioApp'


target 'FinancePortfolioApp' do
  target 'FinancePortfolioAppTests' do
    inherit! :search_paths
		pod 'Quick'
		pod 'Nimble'
  end
end

target 'Component' do
	project 'Component/Component.project'
end

target 'Data' do
	project 'Data/Data.project'
end

target 'Domain' do
	project 'Domain/Domain.project'
end

target 'Networking' do
	project 'Networking/Networking.project'
end

target 'Utility' do
	project 'Utility/Utility.project'
end
