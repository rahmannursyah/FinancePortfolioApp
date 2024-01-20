# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!

workspace 'FinancePortfolioApp'


target 'FinancePortfolioApp' do
	pod 'SwiftyJSON'
	pod 'DGCharts', '5.0.0'
  target 'FinancePortfolioAppTests' do
    inherit! :search_paths
		pod 'Quick', '7.3.0'
		pod 'Nimble', '13.1.2'
  end
end

target 'CommonExtension' do
	project 'CommonExtension/CommonExtension.project'
end

target 'Component' do
	project 'Component/Component.project'
end

target 'Data' do
	project 'Data/Data.project'
	pod 'SwiftyJSON'
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
