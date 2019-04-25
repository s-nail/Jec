-- ----------------------------
-- Table structure for user_login(用户登录表)
-- ----------------------------
DROP TABLE IF EXISTS `user_login`;
CREATE TABLE `user_login` (
  `user_id` varchar(11) NOT NULL COMMENT '用户编号',
  `login_name` varchar(20) DEFAULT NULL COMMENT '用户登录名',
  `password` varchar(32) DEFAULT NULL COMMENT '密码',
  `user_status` int(1) DEFAULT NULL COMMENT '用户状态(1 正常，0 注销)',
  `modified_time` datetime DEFAULT NULL COMMENT '最后修改时间',
  PRIMARY KEY (`user_id`),
  INDEX `idx_loginname` (`login_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '用户登录表';

-- ----------------------------
-- Table structure for user_info(用户信息表)
-- ----------------------------
DROP TABLE IF EXISTS `user_info`;
CREATE TABLE `user_info` (
  `id` varchar(11) DEFAULT NULL COMMENT '主键ID',
  `user_id` varchar(11) DEFAULT NULL COMMENT '用户编号',
  `user_name` varchar(20) DEFAULT NULL COMMENT '用户姓名',
  `card_no` varchar(30) DEFAULT '' COMMENT '身份证号码',
  `phone` varchar(11) DEFAULT NULL COMMENT '手机号',
  `email` varchar(30) DEFAULT NULL COMMENT '邮箱',
  `gender` char(1) DEFAULT '' COMMENT '性别(1 男 2 女)',
  `user_credit` int(10) DEFAULT NULL COMMENT '用户积分',
  `customer_level` varchar(255) DEFAULT NULL COMMENT '会员级别：1 普通会员，2 青铜，3白银，4黄金，5钻石',
  `user_money` decimal(20,0) DEFAULT NULL COMMENT '用户余额',
  `modified_time` datetime DEFAULT NULL COMMENT '最后修改时间',
  `created_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_userid_username_phone` (`user_id`, `user_name`, `phone`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '用户信息表';

-- ----------------------------
-- Table structure for order(订单表)

-- 订单对应订单商品表（订单商品详情表 (order_detail)），一个订单可以对应同一商家的多个商品，不能包含不同商家的商品，一个订单只能属于一个商家
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
  `order_no` varchar(11) NOT NULL COMMENT '订单编号',
  `shop_id` varchar(11) DEFAULT NULL COMMENT '商店编号',
  `order_status` int(1) DEFAULT NULL COMMENT '订单状态(未付款,已付款,已发货,已签收,退货申请,退货中,已退货,取消交易)',
  `product_count` int(8) DEFAULT NULL COMMENT '商品数量',
  `product_amount_total` decimal(20,0) DEFAULT NULL COMMENT '商品总价',
  `order_amount_total` decimal(20,0) DEFAULT NULL COMMENT '订单金额',
  `address_id` varchar(11) DEFAULT '' COMMENT '收货地址编号',
  `logistics_fee` decimal(10,0) DEFAULT NULL COMMENT '运费金额',
  `order_logistics_id` varchar(11) DEFAULT NULL COMMENT '订单物流编号',
  `pay_channel` int(1) DEFAULT NULL COMMENT '订单支付渠道(微信,支付宝,银联)',
  `pay_trade_no` varchar(11) DEFAULT NULL COMMENT '订单支付单号 ',
  `created_time` datetime DEFAULT NULL COMMENT '创建时间(下单时间)',
  `paid_time` datetime DEFAULT NULL COMMENT '付款时间',
  `delivery_time` datetime DEFAULT NULL COMMENT '发货时间',
  `user_id` varchar(11) DEFAULT NULL COMMENT '客户编号',
  `user_remark` varchar(255) DEFAULT NULL COMMENT '客户备注',
  PRIMARY KEY (`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '订单表';

-- ----------------------------
-- Table structure for product_info(商品信息表)
-- ----------------------------
DROP TABLE IF EXISTS `product_info`;
CREATE TABLE `product_info` (
  `product_no` varchar(11) DEFAULT NULL COMMENT '商品编号',
  `product_name` varchar(50) DEFAULT NULL COMMENT '商品名称',
  `product_price` decimal(20,0) DEFAULT NULL COMMENT '商品价格',
  `product_store_barcode` varchar(30) DEFAULT NULL COMMENT '商品条码',
  `product_mode_desc` varchar(100) DEFAULT NULL COMMENT '商品型号信息(记录详细商品型号，如颜色、规格、包装等)',
  `product_mode_params` varchar(100) DEFAULT NULL COMMENT '商品型号参数（JSON格式，记录单位编号、颜色编号、规格编号等）',
  `product_img_url` varchar(100) DEFAULT NULL COMMENT '商品主图',
  `status` int(1) DEFAULT NULL COMMENT '状态：-1 已删除 0 下架 1 上架',
  `desc` varchar(255) DEFAULT NULL COMMENT '商品描述',
  `created_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`product_no`),
  INDEX `idx_productname` (`product_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '商品信息表';

-- ----------------------------
-- Table structure for order_product_detail(订单商品详情表)

-- 设计说明：商品可能被修改、删除等，因此这里要记录下单时用户关注的商品交易摘要信息，如价格、数量、型号、型号参数等。
-- 这样就算后来商品被删除了，用户在查看历史订单的时候也依然能看到商品的快照信息。
-- ----------------------------
DROP TABLE IF EXISTS `order_product_detail`;
CREATE TABLE `order_product_detail` (
  `id` varchar(11) DEFAULT NULL COMMENT '主键ID',
  `order_no` varchar(11) DEFAULT NULL COMMENT '订单编号',
  `product_no` varchar(11) DEFAULT NULL COMMENT '商品编号',
  `product_name` varchar(50) DEFAULT NULL COMMENT '商品名称( 商品可能删除,所以这里要记录，不能直接读商品表)',
  `product_price` decimal(20,0) DEFAULT NULL COMMENT '商品价格(商品可能删除,所以这里要记录)',
  `product_store_barcode` varchar(30) DEFAULT NULL COMMENT ' 商品条码',
  `product_mode_desc` varchar(100) DEFAULT NULL COMMENT '商品型号信息(记录详细商品型号，如颜色、规格、包装等)',
  `product_mode_params` varchar(100) DEFAULT NULL COMMENT '商品型号参数（JSON格式，记录单位编号、颜色编号、规格编号等）',
  `discount_rate` double(2,0) DEFAULT NULL COMMENT '折扣比例',
  `discount_amount` decimal(20,0) DEFAULT NULL COMMENT '折扣金额',
  `number` int(5) DEFAULT NULL COMMENT '购买数量',
  `subtotal` decimal(20,0) DEFAULT NULL COMMENT '小计金额',
  `product_exists_flag` int(1) DEFAULT 0 COMMENT '商品是否有效(是否被删除)',
  PRIMARY KEY (`id`),
  INDEX `idx_orderno_productno` (`order_no`, `product_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '订单商品详情表';


-- ----------------------------
-- Table structure for product_inventory(商品库存表)
-- ----------------------------
DROP TABLE IF EXISTS `product_inventory`;
CREATE TABLE `product_inventory` (
  `id` int(11) NOT NULL,
  `product_no` varchar(11) DEFAULT '' COMMENT '商品编号',
  `current_count` int(5) DEFAULT NULL COMMENT '当前商品数量',
  `lock_count` int(5) DEFAULT NULL COMMENT '当前占用数据 (没付款)',
  `modified_time` datetime DEFAULT NULL COMMENT '最后修改时间',
  PRIMARY KEY (`id`),
  INDEX `idx_productno` (`product_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '商品库存表';

-- ----------------------------
-- Table structure for shopping_cart(购物车)

-- 设计说明：商品价格和小计金额是要通过实时关联商品表来读取和计算，因为商户可能会更改商品价格，或者商品已售罄，或者商品已下架等，
-- 因此这里只需要记录商品id就可以，商品价格等要实时从商品表读取。
-- ----------------------------
DROP TABLE IF EXISTS `shopping_cart`;
CREATE TABLE `shopping_cart` (
  `id` varchar(11) NOT NULL COMMENT '主键ID',
  `user_id` varchar(11) DEFAULT NULL COMMENT '用户编号',
  `shop_id` varchar(11) DEFAULT NULL COMMENT '商店编号',
  `product_id` varchar(11) DEFAULT NULL COMMENT '商品编号',
  `product_exists_flag` int(1) DEFAULT 1 COMMENT '是否有效',
  `number` int(5) DEFAULT NULL COMMENT '购买数量',
  `created_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_userid` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '购物车表';

-- ----------------------------
-- Table structure for delivery_address(收货地址表)
-- ----------------------------
DROP TABLE IF EXISTS `delivery_address`;
CREATE TABLE `delivery_address` (
  `address_id` varchar(11) DEFAULT NULL COMMENT '主键ID',
  `user_id` varchar(11) DEFAULT NULL COMMENT '用户编号',
  `real_name` varchar(30) DEFAULT NULL COMMENT '收件人姓名',
  `telphone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `country` varchar(20) DEFAULT NULL COMMENT '国家 ',
  `province` varchar(20) DEFAULT NULL COMMENT '省份',
  `city` varchar(20) DEFAULT NULL COMMENT '城市',
  `area` varchar(30) DEFAULT NULL COMMENT '地区',
  `street` varchar(255) DEFAULT NULL COMMENT '街道/详细收货地址',
  `zip_code` varchar(10) DEFAULT NULL COMMENT '邮政编码',
  `default_address_flag` int(1) DEFAULT NULL COMMENT '是否默认收货地址',
  `created_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`address_id`),
  INDEX `idx_userid_realname_phone` (`user_id`, `real_name`, `telphone`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '收货地址表';
