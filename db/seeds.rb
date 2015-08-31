city = City.create(description:"北京市")

provinces = Province.create([
 {description: '北京', cities: city},
 {description: '天津'},
 {description: '上海'},
 {description: '河北'}
])
