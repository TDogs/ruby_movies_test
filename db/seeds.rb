# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



admin_power = AdminPower.create!(
  menu_id: "1,2,3,4,5,6",
  name: "超级管理员",
  status: 1
)

p "✅ admin_power 创建成功！ID: #{admin_power.id}"


p "--------------------------------"


admin = Admin.create!(
  username: "admin",
  password: "Admin@123",
  phone: "13800000000",
  role: admin_power.id
)

p "✅ admin 创建成功！ID: #{admin.id}"


p "--------------------------------"

# create public fields
common = { is_deleted: false, keep_alive: true, show: true }

# create menus
AdminMenu.create!(
  common.merge(
    title: "首页",
    path: "/index",
    parent_m_id: 0,
    icon: "home"
  )
)

system = AdminMenu.create!(
  common.merge(
    title: "系统管理",
    path: "/system",
    parent_m_id: 0,
    icon: "cog"
  )
)

film = AdminMenu.create!(
  common.merge(
    title: "影视管理",
    path: "/vab",
    parent_m_id: 0,
    icon: "box-open"
  )
)

# create children menus
AdminMenu.create!(
  [
    common.merge(
      title: "菜单管理",
      path: "/system/menu",
      parent_m_id: system.id,
      icon: ""
    ),
    common.merge(
      title: "系统设置",
      path: "/system/settings",
      parent_m_id: system.id,
      icon: ""
    ),
    common.merge(
      title: "电影列表",
      path: "/vab/movies",
      parent_m_id: film.id,
      icon: ""
    )
  ]
)

p "✅ admin_menu 创建成功！共 #{AdminMenu.count} 条"




p "--------------------------------"


movies = Movie.find_or_create_by!(source_id: 1) do |m|
  m.assign_attributes(
    actors: [ { "name": "张国荣", "role": "饰：旭仔", "image": "https://p0.meituan.net/movie/5de69a492dcbd3f4b014503d4e95d46c28837.jpg@128w_170h_1e_1c" }, { "name": "张曼玉", "role": "饰：苏丽珍", "image": "https://p0.meituan.net/movie/c48c4d1e6f4065a1ff9bc182ed43aa5048545.jpg@128w_170h_1e_1c" }, { "name": "刘德华", "role": "饰：警察超仔", "image": "https://p0.meituan.net/moviemachine/9312e90f25f5ad40f2ceb4561f6fa08830409.jpg@128w_170h_1e_1c" }, { "name": "刘嘉玲", "role": "饰：梁凤英", "image": "https://p1.meituan.net/movie/af1cc9550261e2170333e501db1b3901135228.jpg@128w_170h_1e_1c" }, { "name": "张学友", "role": "饰：歪仔", "image": "https://p1.meituan.net/movie/1ef687c18472b4d7bcca305a3bad429049885.jpg@128w_170h_1e_1c" } ],
    categories: [ "剧情", "爱情", "犯罪" ],
    directors: [ { "name": "王家卫", "image": "https://p0.meituan.net/moviemachine/a415fe2facc573cb79e39bfedfc344bb152810.jpg@128w_170h_1e_1c" } ],
    drama: "详情描述",
    duration_minutes: 122,
    is_deleted: 0,
    poster_url: "https://p0.meituan.net/movie/85215b28d568ea8e2c97766edd95f890210522.jpg@464w_644h_1e_1c",
    rating: 9.0,
    region: "中国香港",
    release_date: "1990-09-14",
    source_url: "https://example.com/detail/1",
    subtitle: [ "https://p0.meituan.net/movie/b6a82b219512790b652284f05b5d063638168.jpg@106w_106h_1e_1c", "https://p1.meituan.net/movie/8c1e5185de6e223f0391f96a337dfa33100586.jpg@106w_106h_1e_1c", "https://p1.meituan.net/movie/eacfa386bdce0d028a443a60de340a7161398.jpg@106w_106h_1e_1c", "https://p1.meituan.net/movie/2db12e51f5998e8385e347a1ef8d6bcb268784.jpg@106w_106h_1e_1c", "https://p0.meituan.net/movie/bb24d27c5a335a61444b825250d7a82b107118.jpg@106w_106h_1e_1c", "https://p1.meituan.net/movie/b1c4009ab9719e24d0efab27b7a8254873722.jpg@106w_106h_1e_1c" ],
    title: "阿飞正传 - Days of Being Wild"
  )
end
p "✅ movies 就绪！ID: #{movies.id}"


p "--------------------------------"
