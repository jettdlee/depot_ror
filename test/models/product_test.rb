require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products


  test "produce attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(
      title: "skjbsdf"
      description: "skljhbsdb"
      image_url: "test.png"
    )   

    product.price = -1
    assert product.invalid?
    assert_equal ["> 0.01"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["< 0.01"], product.errors[:price]
    
    product.price = 1
    assert product.valid?

  end

  def new_product(image_url)
    Product.new(
      title: "hsbjhs",
      description: "kjsbjk",
      price: 1,
      image_url: image_url
    )
  end

  test "image url" do
    ok = %w{test.gif test.jpg test.png http://a.b.c/test.gif }
    bad = %w{test.doc test.gif/more}

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(
      title: products(:ruby).title,
      description: "yyy",
      price: 1,
      image_url: "test.png"
    )

    assert product.invalid?
    assert_equal ['has already been taken'], product.errors[:title]
  end




end
