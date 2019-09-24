# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_20_162356) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "record_type", limit: 255, null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "key", limit: 255, null: false
    t.string "filename", limit: 255, null: false
    t.string "content_type", limit: 255
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", limit: 255, null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "friendly_id_slugs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "slug", limit: 255, null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "retail_product_to_spree_product", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "retail_product_id"
    t.integer "spree_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["retail_product_id"], name: "index_retail_product_to_spree_product_on_retail_product_id"
  end

  create_table "retail_stores_spree_users", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "retail_store_id"
    t.integer "spree_user_id"
    t.index ["retail_store_id"], name: "index_retail_stores_spree_users_on_retail_store_id"
  end

  create_table "site_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "site_name", limit: 255, null: false
    t.integer "other_site_category_id"
    t.integer "mapped_taxon_id"
    t.integer "parent_id"
    t.integer "position", default: 1
    t.string "name", limit: 255
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lft"], name: "index_site_categories_on_lft"
    t.index ["parent_id"], name: "index_site_categories_on_parent_id"
    t.index ["position"], name: "index_site_categories_on_position"
    t.index ["rgt"], name: "index_site_categories_on_rgt"
    t.index ["site_name", "name"], name: "index_site_categories_on_site_name_and_name"
    t.index ["site_name"], name: "index_site_categories_on_site_name"
  end

  create_table "spree_addresses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "firstname", limit: 255
    t.string "lastname", limit: 255
    t.string "address1", limit: 255
    t.string "address2", limit: 255
    t.string "city", limit: 255
    t.string "zipcode", limit: 255
    t.string "phone", limit: 255
    t.string "state_name", limit: 255
    t.string "alternative_phone", limit: 255
    t.string "company", limit: 255
    t.integer "state_id"
    t.integer "country_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["country_id"], name: "index_spree_addresses_on_country_id"
    t.index ["firstname"], name: "index_addresses_on_firstname"
    t.index ["lastname"], name: "index_addresses_on_lastname"
    t.index ["state_id"], name: "index_spree_addresses_on_state_id"
  end

  create_table "spree_adjustment_reasons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "code", limit: 255
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["active"], name: "index_spree_adjustment_reasons_on_active"
    t.index ["code"], name: "index_spree_adjustment_reasons_on_code"
  end

  create_table "spree_adjustments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "source_type", limit: 255
    t.integer "source_id"
    t.string "adjustable_type", limit: 255
    t.integer "adjustable_id", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.string "label", limit: 255
    t.boolean "eligible", default: true
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.integer "order_id", null: false
    t.boolean "included", default: false
    t.integer "promotion_code_id"
    t.integer "adjustment_reason_id"
    t.boolean "finalized", default: false, null: false
    t.index ["adjustable_id", "adjustable_type"], name: "index_spree_adjustments_on_adjustable_id_and_adjustable_type"
    t.index ["adjustable_id"], name: "index_adjustments_on_order_id"
    t.index ["eligible"], name: "index_spree_adjustments_on_eligible"
    t.index ["order_id"], name: "index_spree_adjustments_on_order_id"
    t.index ["promotion_code_id"], name: "index_spree_adjustments_on_promotion_code_id"
    t.index ["source_id", "source_type"], name: "index_spree_adjustments_on_source_id_and_source_type"
  end

  create_table "spree_assets", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "viewable_type", limit: 255
    t.integer "viewable_id"
    t.integer "attachment_width"
    t.integer "attachment_height"
    t.integer "attachment_file_size"
    t.integer "position"
    t.string "attachment_content_type", limit: 255
    t.string "attachment_file_name", limit: 255
    t.string "type", limit: 75
    t.datetime "attachment_updated_at"
    t.text "alt", limit: 16777215
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["viewable_id"], name: "index_assets_on_viewable_id"
    t.index ["viewable_type", "type"], name: "index_assets_on_viewable_type_and_type"
  end

  create_table "spree_calculators", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "type", limit: 255
    t.string "calculable_type", limit: 255
    t.integer "calculable_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.text "preferences", limit: 16777215
    t.index ["calculable_id", "calculable_type"], name: "index_spree_calculators_on_calculable_id_and_calculable_type"
    t.index ["id", "type"], name: "index_spree_calculators_on_id_and_type"
  end

  create_table "spree_cartons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "number", limit: 255
    t.string "external_number", limit: 255
    t.integer "stock_location_id"
    t.integer "address_id"
    t.integer "shipping_method_id"
    t.string "tracking", limit: 255
    t.datetime "shipped_at"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.integer "imported_from_shipment_id"
    t.index ["external_number"], name: "index_spree_cartons_on_external_number"
    t.index ["imported_from_shipment_id"], name: "index_spree_cartons_on_imported_from_shipment_id", unique: true
    t.index ["number"], name: "index_spree_cartons_on_number", unique: true
    t.index ["stock_location_id"], name: "index_spree_cartons_on_stock_location_id"
  end

  create_table "spree_countries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "iso_name", limit: 255
    t.string "iso", limit: 255
    t.string "iso3", limit: 255
    t.string "name", limit: 255
    t.integer "numcode"
    t.boolean "states_required", default: false
    t.datetime "updated_at", precision: 6
    t.datetime "created_at", precision: 6
    t.index ["iso"], name: "index_spree_countries_on_iso"
  end

  create_table "spree_credit_cards", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "month", limit: 255
    t.string "year", limit: 255
    t.string "cc_type", limit: 255
    t.string "last_digits", limit: 255
    t.string "gateway_customer_profile_id", limit: 255
    t.string "gateway_payment_profile_id", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.string "name", limit: 255
    t.integer "user_id"
    t.integer "payment_method_id"
    t.boolean "default", default: false, null: false
    t.integer "address_id"
    t.index ["payment_method_id"], name: "index_spree_credit_cards_on_payment_method_id"
    t.index ["user_id"], name: "index_spree_credit_cards_on_user_id"
  end

  create_table "spree_customer_returns", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "number", limit: 255
    t.integer "stock_location_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
  end

  create_table "spree_inventory_units", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "state", limit: 255
    t.integer "variant_id"
    t.integer "shipment_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.boolean "pending", default: true
    t.integer "line_item_id"
    t.integer "carton_id"
    t.index ["carton_id"], name: "index_spree_inventory_units_on_carton_id"
    t.index ["line_item_id"], name: "index_spree_inventory_units_on_line_item_id"
    t.index ["shipment_id"], name: "index_inventory_units_on_shipment_id"
    t.index ["variant_id"], name: "index_inventory_units_on_variant_id"
  end

  create_table "spree_line_item_actions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "line_item_id", null: false
    t.integer "action_id", null: false
    t.integer "quantity", default: 0
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["action_id"], name: "index_spree_line_item_actions_on_action_id"
    t.index ["line_item_id"], name: "index_spree_line_item_actions_on_line_item_id"
  end

  create_table "spree_line_items", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "variant_id"
    t.integer "order_id"
    t.integer "quantity", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.decimal "cost_price", precision: 10, scale: 2
    t.integer "tax_category_id"
    t.decimal "adjustment_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "additional_tax_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "promo_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "included_tax_total", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["order_id"], name: "index_spree_line_items_on_order_id"
    t.index ["variant_id"], name: "index_spree_line_items_on_variant_id"
  end

  create_table "spree_log_entries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "source_type", limit: 255
    t.integer "source_id"
    t.text "details", limit: 16777215
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["source_id", "source_type"], name: "index_spree_log_entries_on_source_id_and_source_type"
  end

  create_table "spree_option_type_prototypes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "prototype_id"
    t.integer "option_type_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
  end

  create_table "spree_option_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 100
    t.string "presentation", limit: 100
    t.integer "position", default: 0, null: false
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["name"], name: "index_spree_option_types_on_name"
    t.index ["position"], name: "index_spree_option_types_on_position"
  end

  create_table "spree_option_values", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "position"
    t.string "name", limit: 255
    t.string "presentation", limit: 255
    t.integer "option_type_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.string "extra_value", limit: 255
    t.index ["option_type_id"], name: "index_spree_option_values_on_option_type_id"
    t.index ["position"], name: "index_spree_option_values_on_position"
  end

  create_table "spree_option_values_variants", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "variant_id"
    t.integer "option_value_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["variant_id", "option_value_id"], name: "index_option_values_variants_on_variant_id_and_option_value_id"
    t.index ["variant_id"], name: "index_spree_option_values_variants_on_variant_id"
  end

  create_table "spree_order_mutexes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "order_id", null: false
    t.datetime "created_at", precision: 6
    t.index ["order_id"], name: "index_spree_order_mutexes_on_order_id", unique: true
  end

  create_table "spree_orders", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "number", limit: 32
    t.decimal "item_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.string "state", limit: 255
    t.decimal "adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "user_id"
    t.datetime "completed_at"
    t.integer "bill_address_id"
    t.integer "ship_address_id"
    t.decimal "payment_total", precision: 10, scale: 2, default: "0.0"
    t.string "shipment_state", limit: 255
    t.string "payment_state", limit: 255
    t.string "email", limit: 255
    t.text "special_instructions", limit: 16777215
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.string "currency", limit: 255
    t.string "last_ip_address", limit: 255
    t.integer "created_by_id"
    t.decimal "shipment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "additional_tax_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "promo_total", precision: 10, scale: 2, default: "0.0"
    t.string "channel", limit: 255, default: "spree"
    t.decimal "included_tax_total", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "item_count", default: 0
    t.integer "approver_id"
    t.datetime "approved_at"
    t.boolean "confirmation_delivered", default: false
    t.string "guest_token", limit: 255
    t.datetime "canceled_at"
    t.integer "canceler_id"
    t.integer "store_id"
    t.string "approver_name", limit: 255
    t.boolean "frontend_viewable", default: true, null: false
    t.index ["approver_id"], name: "index_spree_orders_on_approver_id"
    t.index ["bill_address_id"], name: "index_spree_orders_on_bill_address_id"
    t.index ["completed_at"], name: "index_spree_orders_on_completed_at"
    t.index ["created_by_id"], name: "index_spree_orders_on_created_by_id"
    t.index ["guest_token"], name: "index_spree_orders_on_guest_token"
    t.index ["number"], name: "index_spree_orders_on_number"
    t.index ["ship_address_id"], name: "index_spree_orders_on_ship_address_id"
    t.index ["user_id", "created_by_id"], name: "index_spree_orders_on_user_id_and_created_by_id"
    t.index ["user_id"], name: "index_spree_orders_on_user_id"
  end

  create_table "spree_orders_promotions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "order_id"
    t.integer "promotion_id"
    t.integer "promotion_code_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["order_id", "promotion_id"], name: "index_spree_orders_promotions_on_order_id_and_promotion_id"
    t.index ["promotion_code_id"], name: "index_spree_orders_promotions_on_promotion_code_id"
  end

  create_table "spree_payment_capture_events", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.integer "payment_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["payment_id"], name: "index_spree_payment_capture_events_on_payment_id"
  end

  create_table "spree_payment_methods", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "type", limit: 255
    t.string "name", limit: 255
    t.text "description", limit: 16777215
    t.boolean "active", default: true
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.boolean "auto_capture"
    t.text "preferences", limit: 16777215
    t.string "preference_source", limit: 255
    t.integer "position", default: 0
    t.boolean "available_to_users", default: true
    t.boolean "available_to_admin", default: true
    t.index ["id", "type"], name: "index_spree_payment_methods_on_id_and_type"
  end

  create_table "spree_payments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "order_id"
    t.string "source_type", limit: 255
    t.integer "source_id"
    t.integer "payment_method_id"
    t.string "state", limit: 255
    t.string "response_code", limit: 255
    t.string "avs_response", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.string "number", limit: 255
    t.string "cvv_response_code", limit: 255
    t.string "cvv_response_message", limit: 255
    t.integer "payable_id"
    t.string "payable_type", limit: 255
    t.index ["number"], name: "index_spree_payments_on_number", unique: true
    t.index ["order_id"], name: "index_spree_payments_on_order_id"
    t.index ["payable_id", "payable_type"], name: "index_spree_payments_on_payable_id_and_payable_type"
    t.index ["payment_method_id"], name: "index_spree_payments_on_payment_method_id"
    t.index ["source_id", "source_type"], name: "index_spree_payments_on_source_id_and_source_type"
  end

  create_table "spree_preferences", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "value", limit: 16777215
    t.string "key", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["key"], name: "index_spree_preferences_on_key", unique: true
  end

  create_table "spree_prices", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "variant_id", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.string "currency", limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.string "country_iso", limit: 2
    t.index ["country_iso"], name: "index_spree_prices_on_country_iso"
    t.index ["variant_id", "currency"], name: "index_spree_prices_on_variant_id_and_currency"
  end

  create_table "spree_product_option_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "position"
    t.integer "product_id"
    t.integer "option_type_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["option_type_id"], name: "index_spree_product_option_types_on_option_type_id"
    t.index ["position"], name: "index_spree_product_option_types_on_position"
    t.index ["product_id"], name: "index_spree_product_option_types_on_product_id"
  end

  create_table "spree_product_promotion_rules", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "product_id"
    t.integer "promotion_rule_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["product_id"], name: "index_products_promotion_rules_on_product_id"
    t.index ["promotion_rule_id"], name: "index_products_promotion_rules_on_promotion_rule_id"
  end

  create_table "spree_product_properties", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "value", limit: 255
    t.integer "product_id"
    t.integer "property_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.integer "position", default: 0
    t.index ["position"], name: "index_spree_product_properties_on_position"
    t.index ["product_id"], name: "index_product_properties_on_product_id"
    t.index ["property_id"], name: "index_spree_product_properties_on_property_id"
  end

  create_table "spree_products", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.text "description", limit: 16777215
    t.datetime "available_on"
    t.datetime "deleted_at"
    t.string "slug", limit: 255
    t.text "meta_description", limit: 16777215
    t.string "meta_keywords", limit: 255
    t.integer "tax_category_id"
    t.integer "shipping_category_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.boolean "promotionable", default: true
    t.string "meta_title", limit: 255
    t.integer "user_id"
    t.integer "master_product_id"
    t.integer "view_count", default: 0
    t.integer "transaction_count", default: 0
    t.integer "engagement_count", default: 0
    t.float "gross_merchandise_sales", default: 0.0
    t.index ["available_on"], name: "index_spree_products_on_available_on"
    t.index ["deleted_at"], name: "index_spree_products_on_deleted_at"
    t.index ["master_product_id"], name: "index_spree_products_on_master_product_id"
    t.index ["name"], name: "index_spree_products_on_name"
    t.index ["slug"], name: "index_spree_products_on_slug", unique: true
    t.index ["user_id"], name: "index_spree_products_on_user_id"
  end

  create_table "spree_products_taxons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "product_id"
    t.integer "taxon_id"
    t.integer "position"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["position"], name: "index_spree_products_taxons_on_position"
    t.index ["product_id"], name: "index_spree_products_taxons_on_product_id"
    t.index ["taxon_id"], name: "index_spree_products_taxons_on_taxon_id"
  end

  create_table "spree_promotion_action_line_items", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "promotion_action_id"
    t.integer "variant_id"
    t.integer "quantity", default: 1
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["promotion_action_id"], name: "index_spree_promotion_action_line_items_on_promotion_action_id"
    t.index ["variant_id"], name: "index_spree_promotion_action_line_items_on_variant_id"
  end

  create_table "spree_promotion_actions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "promotion_id"
    t.integer "position"
    t.string "type", limit: 255
    t.datetime "deleted_at"
    t.text "preferences", limit: 16777215
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["deleted_at"], name: "index_spree_promotion_actions_on_deleted_at"
    t.index ["id", "type"], name: "index_spree_promotion_actions_on_id_and_type"
    t.index ["promotion_id"], name: "index_spree_promotion_actions_on_promotion_id"
  end

  create_table "spree_promotion_categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.string "code", limit: 255
  end

  create_table "spree_promotion_code_batches", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "promotion_id", null: false
    t.string "base_code", limit: 255, null: false
    t.integer "number_of_codes", null: false
    t.string "email", limit: 255
    t.string "error", limit: 255
    t.string "state", limit: 255, default: "pending"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "join_characters", limit: 255, default: "_", null: false
    t.index ["promotion_id"], name: "index_spree_promotion_code_batches_on_promotion_id"
  end

  create_table "spree_promotion_codes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "promotion_id", null: false
    t.string "value", limit: 255, null: false
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.integer "promotion_code_batch_id"
    t.index ["promotion_code_batch_id"], name: "index_spree_promotion_codes_on_promotion_code_batch_id"
    t.index ["promotion_id"], name: "index_spree_promotion_codes_on_promotion_id"
    t.index ["value"], name: "index_spree_promotion_codes_on_value", unique: true
  end

  create_table "spree_promotion_rule_taxons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "taxon_id"
    t.integer "promotion_rule_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["promotion_rule_id"], name: "index_spree_promotion_rule_taxons_on_promotion_rule_id"
    t.index ["taxon_id"], name: "index_spree_promotion_rule_taxons_on_taxon_id"
  end

  create_table "spree_promotion_rules", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "promotion_id"
    t.integer "product_group_id"
    t.string "type", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.string "code", limit: 255
    t.text "preferences", limit: 16777215
    t.index ["product_group_id"], name: "index_promotion_rules_on_product_group_id"
    t.index ["promotion_id"], name: "index_spree_promotion_rules_on_promotion_id"
  end

  create_table "spree_promotion_rules_stores", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "promotion_rule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["promotion_rule_id"], name: "index_spree_promotion_rules_stores_on_promotion_rule_id"
    t.index ["store_id"], name: "index_spree_promotion_rules_stores_on_store_id"
  end

  create_table "spree_promotion_rules_users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "promotion_rule_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["promotion_rule_id"], name: "index_promotion_rules_users_on_promotion_rule_id"
    t.index ["user_id"], name: "index_promotion_rules_users_on_user_id"
  end

  create_table "spree_promotions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "description", limit: 255
    t.datetime "expires_at"
    t.datetime "starts_at"
    t.string "name", limit: 255
    t.string "type", limit: 255
    t.integer "usage_limit"
    t.string "match_policy", limit: 255, default: "all"
    t.boolean "advertise", default: false
    t.string "path", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.integer "promotion_category_id"
    t.integer "per_code_usage_limit"
    t.boolean "apply_automatically", default: false
    t.index ["advertise"], name: "index_spree_promotions_on_advertise"
    t.index ["apply_automatically"], name: "index_spree_promotions_on_apply_automatically"
    t.index ["expires_at"], name: "index_spree_promotions_on_expires_at"
    t.index ["id", "type"], name: "index_spree_promotions_on_id_and_type"
    t.index ["promotion_category_id"], name: "index_spree_promotions_on_promotion_category_id"
    t.index ["starts_at"], name: "index_spree_promotions_on_starts_at"
  end

  create_table "spree_properties", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "presentation", limit: 255, null: false
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
  end

  create_table "spree_property_prototypes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "prototype_id"
    t.integer "property_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
  end

  create_table "spree_prototype_taxons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "taxon_id"
    t.integer "prototype_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["prototype_id"], name: "index_spree_prototype_taxons_on_prototype_id"
    t.index ["taxon_id"], name: "index_spree_prototype_taxons_on_taxon_id"
  end

  create_table "spree_prototypes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
  end

  create_table "spree_refund_reasons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.boolean "active", default: true
    t.boolean "mutable", default: true
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.string "code", limit: 255
  end

  create_table "spree_refunds", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "payment_id"
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.string "transaction_id", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.integer "refund_reason_id"
    t.integer "reimbursement_id"
    t.index ["payment_id"], name: "index_spree_refunds_on_payment_id"
    t.index ["refund_reason_id"], name: "index_refunds_on_refund_reason_id"
    t.index ["reimbursement_id"], name: "index_spree_refunds_on_reimbursement_id"
  end

  create_table "spree_reimbursement_credits", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "reimbursement_id"
    t.integer "creditable_id"
    t.string "creditable_type", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
  end

  create_table "spree_reimbursement_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.boolean "active", default: true
    t.boolean "mutable", default: true
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.string "type", limit: 255
    t.index ["type"], name: "index_spree_reimbursement_types_on_type"
  end

  create_table "spree_reimbursements", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "number", limit: 255
    t.string "reimbursement_status", limit: 255
    t.integer "customer_return_id"
    t.integer "order_id"
    t.decimal "total", precision: 10, scale: 2
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["customer_return_id"], name: "index_spree_reimbursements_on_customer_return_id"
    t.index ["order_id"], name: "index_spree_reimbursements_on_order_id"
  end

  create_table "spree_return_authorizations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "number", limit: 255
    t.string "state", limit: 255
    t.integer "order_id"
    t.text "memo", limit: 16777215
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.integer "stock_location_id"
    t.integer "return_reason_id"
    t.index ["return_reason_id"], name: "index_return_authorizations_on_return_authorization_reason_id"
  end

  create_table "spree_return_items", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "return_authorization_id"
    t.integer "inventory_unit_id"
    t.integer "exchange_variant_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.decimal "amount", precision: 12, scale: 4, default: "0.0", null: false
    t.decimal "included_tax_total", precision: 12, scale: 4, default: "0.0", null: false
    t.decimal "additional_tax_total", precision: 12, scale: 4, default: "0.0", null: false
    t.string "reception_status", limit: 255
    t.string "acceptance_status", limit: 255
    t.integer "customer_return_id"
    t.integer "reimbursement_id"
    t.integer "exchange_inventory_unit_id"
    t.text "acceptance_status_errors", limit: 16777215
    t.integer "preferred_reimbursement_type_id"
    t.integer "override_reimbursement_type_id"
    t.boolean "resellable", default: true, null: false
    t.integer "return_reason_id"
    t.index ["customer_return_id"], name: "index_return_items_on_customer_return_id"
    t.index ["exchange_inventory_unit_id"], name: "index_spree_return_items_on_exchange_inventory_unit_id"
  end

  create_table "spree_return_reasons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.boolean "active", default: true
    t.boolean "mutable", default: true
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
  end

  create_table "spree_roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["name"], name: "index_spree_roles_on_name", unique: true
  end

  create_table "spree_roles_users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["role_id"], name: "index_spree_roles_users_on_role_id"
    t.index ["user_id", "role_id"], name: "index_spree_roles_users_on_user_id_and_role_id", unique: true
    t.index ["user_id"], name: "index_spree_roles_users_on_user_id"
  end

  create_table "spree_shipments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "tracking", limit: 255
    t.string "number", limit: 255
    t.decimal "cost", precision: 10, scale: 2, default: "0.0"
    t.datetime "shipped_at"
    t.integer "order_id"
    t.integer "deprecated_address_id"
    t.string "state", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.integer "stock_location_id"
    t.decimal "adjustment_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "additional_tax_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "promo_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "included_tax_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "supplier_commission", precision: 8, scale: 2, default: "0.0", null: false
    t.index ["deprecated_address_id"], name: "index_spree_shipments_on_deprecated_address_id"
    t.index ["number"], name: "index_shipments_on_number"
    t.index ["order_id"], name: "index_spree_shipments_on_order_id"
    t.index ["stock_location_id"], name: "index_spree_shipments_on_stock_location_id"
  end

  create_table "spree_shipping_categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
  end

  create_table "spree_shipping_method_categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "shipping_method_id", null: false
    t.integer "shipping_category_id", null: false
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["shipping_category_id", "shipping_method_id"], name: "unique_spree_shipping_method_categories", unique: true
    t.index ["shipping_method_id"], name: "index_spree_shipping_method_categories_on_shipping_method_id"
  end

  create_table "spree_shipping_method_stock_locations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "shipping_method_id"
    t.integer "stock_location_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["shipping_method_id"], name: "shipping_method_id_spree_sm_sl"
    t.index ["stock_location_id"], name: "sstock_location_id_spree_sm_sl"
  end

  create_table "spree_shipping_method_zones", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "shipping_method_id"
    t.integer "zone_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
  end

  create_table "spree_shipping_methods", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.string "tracking_url", limit: 255
    t.string "admin_name", limit: 255
    t.integer "tax_category_id"
    t.string "code", limit: 255
    t.boolean "available_to_all", default: true
    t.string "carrier", limit: 255
    t.string "service_level", limit: 255
    t.boolean "available_to_users", default: true
    t.index ["tax_category_id"], name: "index_spree_shipping_methods_on_tax_category_id"
  end

  create_table "spree_shipping_rate_taxes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "amount", precision: 8, scale: 2, default: "0.0", null: false
    t.integer "tax_rate_id"
    t.integer "shipping_rate_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shipping_rate_id"], name: "index_spree_shipping_rate_taxes_on_shipping_rate_id"
    t.index ["tax_rate_id"], name: "index_spree_shipping_rate_taxes_on_tax_rate_id"
  end

  create_table "spree_shipping_rates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "shipment_id"
    t.integer "shipping_method_id"
    t.boolean "selected", default: false
    t.decimal "cost", precision: 8, scale: 2, default: "0.0"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.integer "tax_rate_id"
    t.index ["shipment_id", "shipping_method_id"], name: "spree_shipping_rates_join_index", unique: true
  end

  create_table "spree_state_changes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "previous_state", limit: 255
    t.integer "stateful_id"
    t.integer "user_id"
    t.string "stateful_type", limit: 255
    t.string "next_state", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["stateful_id", "stateful_type"], name: "index_spree_state_changes_on_stateful_id_and_stateful_type"
    t.index ["user_id"], name: "index_spree_state_changes_on_user_id"
  end

  create_table "spree_states", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "abbr", limit: 255
    t.integer "country_id"
    t.datetime "updated_at", precision: 6
    t.datetime "created_at", precision: 6
    t.index ["country_id"], name: "index_spree_states_on_country_id"
  end

  create_table "spree_stock_items", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "stock_location_id"
    t.integer "variant_id"
    t.integer "count_on_hand", default: 0, null: false
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.boolean "backorderable", default: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_spree_stock_items_on_deleted_at"
    t.index ["stock_location_id", "variant_id"], name: "stock_item_by_loc_and_var_id"
    t.index ["stock_location_id"], name: "index_spree_stock_items_on_stock_location_id"
  end

  create_table "spree_stock_locations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.boolean "default", default: false, null: false
    t.string "address1", limit: 255
    t.string "address2", limit: 255
    t.string "city", limit: 255
    t.integer "state_id"
    t.string "state_name", limit: 255
    t.integer "country_id"
    t.string "zipcode", limit: 255
    t.string "phone", limit: 255
    t.boolean "active", default: true
    t.boolean "backorderable_default", default: false
    t.boolean "propagate_all_variants", default: true
    t.string "admin_name", limit: 255
    t.integer "position", default: 0
    t.boolean "restock_inventory", default: true, null: false
    t.boolean "fulfillable", default: true, null: false
    t.string "code", limit: 255
    t.boolean "check_stock_on_transfer", default: true
    t.integer "supplier_id"
    t.index ["country_id"], name: "index_spree_stock_locations_on_country_id"
    t.index ["state_id"], name: "index_spree_stock_locations_on_state_id"
    t.index ["supplier_id"], name: "index_spree_stock_locations_on_supplier_id"
  end

  create_table "spree_stock_movements", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "stock_item_id"
    t.integer "quantity", default: 0
    t.string "action", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "originator_type", limit: 255
    t.integer "originator_id"
    t.index ["stock_item_id"], name: "index_spree_stock_movements_on_stock_item_id"
  end

  create_table "spree_store_credit_categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
  end

  create_table "spree_store_credit_events", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "store_credit_id", null: false
    t.string "action", limit: 255, null: false
    t.decimal "amount", precision: 8, scale: 2
    t.decimal "user_total_amount", precision: 8, scale: 2, default: "0.0", null: false
    t.string "authorization_code", limit: 255, null: false
    t.datetime "deleted_at"
    t.string "originator_type", limit: 255
    t.integer "originator_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.integer "update_reason_id"
    t.decimal "amount_remaining", precision: 8, scale: 2
    t.integer "store_credit_reason_id"
    t.index ["deleted_at"], name: "index_spree_store_credit_events_on_deleted_at"
    t.index ["store_credit_id"], name: "index_spree_store_credit_events_on_store_credit_id"
  end

  create_table "spree_store_credit_reasons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spree_store_credit_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "priority"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority"], name: "index_spree_store_credit_types_on_priority"
  end

  create_table "spree_store_credit_update_reasons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
  end

  create_table "spree_store_credits", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "category_id"
    t.integer "created_by_id"
    t.decimal "amount", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "amount_used", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "amount_authorized", precision: 8, scale: 2, default: "0.0", null: false
    t.string "currency", limit: 255
    t.text "memo", limit: 16777215
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.integer "type_id"
    t.datetime "invalidated_at"
    t.index ["deleted_at"], name: "index_spree_store_credits_on_deleted_at"
    t.index ["type_id"], name: "index_spree_store_credits_on_type_id"
    t.index ["user_id"], name: "index_spree_store_credits_on_user_id"
  end

  create_table "spree_store_payment_methods", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "store_id", null: false
    t.integer "payment_method_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "account_parameters", limit: 255, default: ""
    t.string "account_label", limit: 255, default: ""
    t.index ["payment_method_id"], name: "index_spree_store_payment_methods_on_payment_method_id"
    t.index ["store_id"], name: "index_spree_store_payment_methods_on_store_id"
  end

  create_table "spree_store_shipping_methods", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "shipping_method_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shipping_method_id"], name: "index_spree_store_shipping_methods_on_shipping_method_id"
    t.index ["store_id"], name: "index_spree_store_shipping_methods_on_store_id"
  end

  create_table "spree_stores", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "url", limit: 255
    t.text "meta_description", limit: 16777215
    t.text "meta_keywords", limit: 16777215
    t.string "seo_title", limit: 255
    t.string "mail_from_address", limit: 255
    t.string "default_currency", limit: 255
    t.string "code", limit: 255
    t.boolean "default", default: false, null: false
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.string "cart_tax_country_iso", limit: 255
    t.string "available_locales", limit: 255
    t.integer "user_id"
    t.index ["code"], name: "index_spree_stores_on_code"
    t.index ["default"], name: "index_spree_stores_on_default"
    t.index ["user_id"], name: "index_spree_stores_on_user_id"
  end

  create_table "spree_supplier_variants", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "supplier_id"
    t.integer "variant_id"
    t.decimal "cost", precision: 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["supplier_id"], name: "index_spree_supplier_variants_on_supplier_id"
    t.index ["variant_id"], name: "index_spree_supplier_variants_on_variant_id"
  end

  create_table "spree_suppliers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.boolean "active", default: false, null: false
    t.integer "address_id"
    t.decimal "commission_flat_rate", precision: 8, scale: 2, default: "0.0", null: false
    t.float "commission_percentage", default: 0.0, null: false
    t.string "email", limit: 255
    t.string "name", limit: 255
    t.string "url", limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "tax_id", limit: 255
    t.string "token", limit: 255
    t.string "slug", limit: 255
    t.string "paypal_email", limit: 255
    t.index ["active"], name: "index_spree_suppliers_on_active"
    t.index ["address_id"], name: "index_spree_suppliers_on_address_id"
    t.index ["deleted_at"], name: "index_spree_suppliers_on_deleted_at"
    t.index ["slug"], name: "index_spree_suppliers_on_slug", unique: true
    t.index ["token"], name: "index_spree_suppliers_on_token"
  end

  create_table "spree_tax_categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.boolean "is_default", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.string "tax_code", limit: 255
  end

  create_table "spree_tax_rate_tax_categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "tax_category_id", null: false
    t.integer "tax_rate_id", null: false
    t.index ["tax_category_id"], name: "index_spree_tax_rate_tax_categories_on_tax_category_id"
    t.index ["tax_rate_id"], name: "index_spree_tax_rate_tax_categories_on_tax_rate_id"
  end

  create_table "spree_tax_rates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "amount", precision: 8, scale: 5
    t.integer "zone_id"
    t.boolean "included_in_price", default: false
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.string "name", limit: 255
    t.boolean "show_rate_in_label", default: true
    t.datetime "deleted_at"
    t.datetime "starts_at"
    t.datetime "expires_at"
    t.index ["deleted_at"], name: "index_spree_tax_rates_on_deleted_at"
    t.index ["zone_id"], name: "index_spree_tax_rates_on_zone_id"
  end

  create_table "spree_taxonomies", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.integer "position", default: 0
    t.index ["name"], name: "index_spree_taxonomies_on_name"
    t.index ["position"], name: "index_spree_taxonomies_on_position"
  end

  create_table "spree_taxons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "position", default: 0
    t.string "name", limit: 255, null: false
    t.string "permalink", limit: 255
    t.integer "taxonomy_id"
    t.integer "lft"
    t.integer "rgt"
    t.string "icon_file_name", limit: 255
    t.string "icon_content_type", limit: 255
    t.integer "icon_file_size"
    t.datetime "icon_updated_at"
    t.text "description", limit: 16777215
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.string "meta_title", limit: 255
    t.string "meta_description", limit: 255
    t.string "meta_keywords", limit: 255
    t.integer "depth"
    t.index ["lft"], name: "index_spree_taxons_on_lft"
    t.index ["name"], name: "index_spree_taxons_on_name"
    t.index ["parent_id"], name: "index_taxons_on_parent_id"
    t.index ["permalink"], name: "index_taxons_on_permalink"
    t.index ["position"], name: "index_spree_taxons_on_position"
    t.index ["rgt"], name: "index_spree_taxons_on_rgt"
    t.index ["taxonomy_id"], name: "index_taxons_on_taxonomy_id"
  end

  create_table "spree_unit_cancels", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "inventory_unit_id", null: false
    t.string "reason", limit: 255
    t.string "created_by", limit: 255
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["inventory_unit_id"], name: "index_spree_unit_cancels_on_inventory_unit_id"
  end

  create_table "spree_user_addresses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "address_id", null: false
    t.boolean "default", default: false
    t.boolean "archived", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address_id"], name: "index_spree_user_addresses_on_address_id"
    t.index ["user_id", "address_id"], name: "index_spree_user_addresses_on_user_id_and_address_id", unique: true
    t.index ["user_id"], name: "index_spree_user_addresses_on_user_id"
  end

  create_table "spree_user_stock_locations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "stock_location_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["user_id"], name: "index_spree_user_stock_locations_on_user_id"
  end

  create_table "spree_users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "encrypted_password", limit: 128
    t.string "password_salt", limit: 128
    t.string "email", limit: 255
    t.string "remember_token", limit: 255
    t.string "persistence_token", limit: 255
    t.string "reset_password_token", limit: 255
    t.string "perishable_token", limit: 255
    t.integer "sign_in_count", default: 0, null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.string "login", limit: 255
    t.integer "ship_address_id"
    t.integer "bill_address_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "spree_api_key", limit: 48
    t.string "authentication_token", limit: 255
    t.string "unlock_token", limit: 255
    t.datetime "locked_at"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.datetime "deleted_at"
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "supplier_id"
    t.string "username", limit: 64
    t.string "display_name", limit: 64
    t.string "country", limit: 64
    t.string "country_code", limit: 16
    t.string "zipcode", limit: 64
    t.string "timezone", limit: 64
    t.integer "non_paying_buyer_count", default: 0
    t.index ["deleted_at"], name: "index_spree_users_on_deleted_at"
    t.index ["email"], name: "email_idx_unique", unique: true
    t.index ["spree_api_key"], name: "index_spree_users_on_spree_api_key"
    t.index ["supplier_id"], name: "index_spree_users_on_supplier_id"
    t.index ["username"], name: "index_spree_users_on_username", unique: true
  end

  create_table "spree_variant_property_rule_conditions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "option_value_id"
    t.integer "variant_property_rule_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["variant_property_rule_id", "option_value_id"], name: "index_spree_variant_prop_rule_conditions_on_rule_and_optval"
  end

  create_table "spree_variant_property_rule_values", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "value", limit: 16777215
    t.integer "position", default: 0
    t.integer "property_id"
    t.integer "variant_property_rule_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["property_id"], name: "index_spree_variant_property_rule_values_on_property_id"
    t.index ["variant_property_rule_id"], name: "index_spree_variant_property_rule_values_on_rule"
  end

  create_table "spree_variant_property_rules", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "product_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_spree_variant_property_rules_on_product_id"
  end

  create_table "spree_variants", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "sku", limit: 255, default: "", null: false
    t.decimal "weight", precision: 8, scale: 2, default: "0.0"
    t.decimal "height", precision: 8, scale: 2
    t.decimal "width", precision: 8, scale: 2
    t.decimal "depth", precision: 8, scale: 2
    t.datetime "deleted_at"
    t.boolean "is_master", default: false
    t.integer "product_id"
    t.decimal "cost_price", precision: 10, scale: 2
    t.integer "position"
    t.string "cost_currency", limit: 255
    t.boolean "track_inventory", default: true
    t.integer "tax_category_id"
    t.datetime "updated_at", precision: 6
    t.datetime "created_at", precision: 6
    t.integer "user_id"
    t.integer "view_count", default: 0
    t.integer "incomplete_transaction_count", default: 0
    t.string "sorting_rank", limit: 32, default: ""
    t.index ["position"], name: "index_spree_variants_on_position"
    t.index ["product_id"], name: "index_spree_variants_on_product_id"
    t.index ["sku"], name: "index_spree_variants_on_sku"
    t.index ["sorting_rank"], name: "index_spree_variants_on_sorting_rank"
    t.index ["tax_category_id"], name: "index_spree_variants_on_tax_category_id"
    t.index ["track_inventory"], name: "index_spree_variants_on_track_inventory"
    t.index ["user_id"], name: "index_spree_variants_on_user_id"
  end

  create_table "spree_wallet_payment_sources", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "payment_source_type", limit: 255, null: false
    t.integer "payment_source_id", null: false
    t.boolean "default", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "payment_source_id", "payment_source_type"], name: "index_spree_wallet_payment_sources_on_source_and_user", unique: true
    t.index ["user_id"], name: "index_spree_wallet_payment_sources_on_user_id"
  end

  create_table "spree_zone_members", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "zoneable_type", limit: 255
    t.integer "zoneable_id"
    t.integer "zone_id"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["zone_id"], name: "index_spree_zone_members_on_zone_id"
    t.index ["zoneable_id", "zoneable_type"], name: "index_spree_zone_members_on_zoneable_id_and_zoneable_type"
  end

  create_table "spree_zones", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.integer "zone_members_count", default: 0
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
  end

  create_table "users_resource_actions", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "user_id"
    t.string "resource_type", limit: 64
    t.integer "resource_id"
    t.string "action", limit: 255, default: "VIEW"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_type", "resource_id"], name: "index_users_resource_actions_on_resource_type_and_resource_id"
    t.index ["user_id", "action"], name: "index_users_resource_actions_on_user_id_and_action"
    t.index ["user_id", "created_at"], name: "index_users_resource_actions_on_user_id_and_created_at"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "spree_promotion_code_batches", "spree_promotions", column: "promotion_id"
  add_foreign_key "spree_promotion_codes", "spree_promotion_code_batches", column: "promotion_code_batch_id"
  add_foreign_key "spree_tax_rate_tax_categories", "spree_tax_categories", column: "tax_category_id"
  add_foreign_key "spree_tax_rate_tax_categories", "spree_tax_rates", column: "tax_rate_id"
  add_foreign_key "spree_wallet_payment_sources", "spree_users", column: "user_id"
end
