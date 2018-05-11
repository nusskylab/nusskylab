# encoding: UTF-8
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


ActiveRecord::Schema.define(version: 20180424190355) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "cohort"
  end

  add_index "admins", ["user_id"], name: "index_admins_on_user_id", using: :btree

  create_table "advisers", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "cohort"
  end

  add_index "advisers", ["user_id"], name: "index_advisers_on_user_id", using: :btree

  create_table "evaluatings", force: :cascade do |t|
    t.integer "evaluator_id", null: false
    t.integer "evaluated_id", null: false
  end

  add_index "evaluatings", ["evaluated_id"], name: "index_evaluatings_on_evaluated_id", using: :btree
  add_index "evaluatings", ["evaluator_id"], name: "index_evaluatings_on_evaluator_id", using: :btree

  create_table "facilitators", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "cohort"
  end

  add_index "facilitators", ["user_id"], name: "index_facilitators_on_user_id", using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "team_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "target_team_id"
    t.integer  "adviser_id"
    t.integer  "target_type"
    t.integer  "survey_template_id"
    t.json     "response_content"
  end

  add_index "feedbacks", ["adviser_id"], name: "index_feedbacks_on_adviser_id", using: :btree
  add_index "feedbacks", ["survey_template_id"], name: "index_feedbacks_on_survey_template_id", using: :btree
  add_index "feedbacks", ["team_id"], name: "index_feedbacks_on_team_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 191, null: false
    t.integer  "sluggable_id",               null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 191
    t.datetime "created_at",                 null: false
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "hash_tags", force: :cascade do |t|
    t.string   "content"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "label",      default: "default"
  end

  add_index "hash_tags", ["content"], name: "index_hash_tags_on_content", using: :btree
  add_index "hash_tags", ["label"], name: "index_hash_tags_on_label", using: :btree

  create_table "mentors", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "cohort"
    t.string   "slide_link", default: "0"
  end

  add_index "mentors", ["user_id"], name: "index_mentors_on_user_id", using: :btree

  create_table "milestones", force: :cascade do |t|
    t.datetime "submission_deadline",      default: '2018-03-19 20:20:35', null: false
    t.string   "name"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.datetime "peer_evaluation_deadline", default: '2018-03-19 20:20:35', null: false
    t.integer  "cohort"
  end

  create_table "peer_evaluations", force: :cascade do |t|
    t.text     "public_content"
    t.text     "private_content"
    t.datetime "created_at",                         null: false
    t.boolean  "published"
    t.integer  "team_id"
    t.integer  "submission_id"
    t.integer  "adviser_id"
    t.string   "owner_type",       default: "teams"
    t.datetime "updated_at",                         null: false
    t.json     "response_content"
  end

  add_index "peer_evaluations", ["adviser_id"], name: "index_peer_evaluations_on_adviser_id", using: :btree
  add_index "peer_evaluations", ["submission_id"], name: "index_peer_evaluations_on_submission_id", using: :btree
  add_index "peer_evaluations", ["team_id"], name: "index_peer_evaluations_on_team_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "title"
    t.text     "content"
    t.text     "instruction"
    t.integer  "question_type",      default: 0
    t.integer  "survey_template_id",                null: false
    t.boolean  "is_public",          default: true
    t.text     "extras"
    t.integer  "order"
  end

  add_index "questions", ["survey_template_id"], name: "index_questions_on_survey_template_id", using: :btree

  create_table "registrations", force: :cascade do |t|
    t.json     "response_content"
    t.integer  "user_id"
    t.integer  "survey_template_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "registrations", ["survey_template_id"], name: "index_registrations_on_survey_template_id", using: :btree
  add_index "registrations", ["user_id"], name: "index_registrations_on_user_id", using: :btree

  create_table "students", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "team_id"
    t.boolean  "is_pending", default: false
    t.integer  "cohort"
  end

  add_index "students", ["team_id"], name: "index_students_on_team_id", using: :btree
  add_index "students", ["user_id"], name: "index_students_on_user_id", using: :btree

  create_table "submissions", force: :cascade do |t|
    t.integer  "milestone_id",                 null: false
    t.integer  "team_id",                      null: false
    t.boolean  "published",    default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "video_link"
    t.text     "read_me"
    t.text     "project_log"
    t.boolean  "show_public",  default: true
    t.string   "poster_link"
  end

  add_index "submissions", ["milestone_id"], name: "index_submissions_on_milestone_id", using: :btree
  add_index "submissions", ["team_id"], name: "index_submissions_on_team_id", using: :btree

  create_table "survey_templates", force: :cascade do |t|
    t.text     "instruction"
    t.datetime "deadline"
    t.integer  "survey_type",  default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "milestone_id"
  end

  add_index "survey_templates", ["milestone_id"], name: "index_survey_templates_on_milestone_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.integer  "adviser_id"
    t.integer  "mentor_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "team_name"
    t.boolean  "has_dropped",        default: false
    t.integer  "project_level",      default: 0
    t.boolean  "is_pending",         default: false
    t.integer  "invitor_student_id"
    t.integer  "cohort"
    t.string   "poster_link"
    t.string   "slide_link"
    t.string   "video_link"
  end

  add_index "teams", ["adviser_id"], name: "index_teams_on_adviser_id", using: :btree
  add_index "teams", ["mentor_id"], name: "index_teams_on_mentor_id", using: :btree

  create_table "thredded_categories", force: :cascade do |t|
    t.integer  "messageboard_id",             null: false
    t.string   "name",            limit: 191, null: false
    t.string   "description",     limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "slug",            limit: 191, null: false
  end

  add_index "thredded_categories", ["messageboard_id", "slug"], name: "index_thredded_categories_on_messageboard_id_and_slug", unique: true, using: :btree
  add_index "thredded_categories", ["messageboard_id"], name: "index_thredded_categories_on_messageboard_id", using: :btree

  create_table "thredded_messageboard_groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "position",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "thredded_messageboard_notifications_for_followed_topics", force: :cascade do |t|
    t.integer "user_id",                                   null: false
    t.integer "messageboard_id",                           null: false
    t.string  "notifier_key",    limit: 90,                null: false
    t.boolean "enabled",                    default: true, null: false
  end

  add_index "thredded_messageboard_notifications_for_followed_topics", ["user_id", "messageboard_id", "notifier_key"], name: "thredded_messageboard_notifications_for_followed_topics_unique", unique: true, using: :btree

  create_table "thredded_messageboard_users", force: :cascade do |t|
    t.integer  "thredded_user_detail_id",  null: false
    t.integer  "thredded_messageboard_id", null: false
    t.datetime "last_seen_at",             null: false
  end

  add_index "thredded_messageboard_users", ["thredded_messageboard_id", "last_seen_at"], name: "index_thredded_messageboard_users_for_recently_active", using: :btree
  add_index "thredded_messageboard_users", ["thredded_messageboard_id", "thredded_user_detail_id"], name: "index_thredded_messageboard_users_primary", using: :btree

  create_table "thredded_messageboards", force: :cascade do |t|
    t.string   "name",                  limit: 191,             null: false
    t.string   "slug",                  limit: 191
    t.text     "description"
    t.integer  "topics_count",                      default: 0
    t.integer  "posts_count",                       default: 0
    t.integer  "position",                                      null: false
    t.integer  "last_topic_id"
    t.integer  "messageboard_group_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "thredded_messageboards", ["messageboard_group_id"], name: "index_thredded_messageboards_on_messageboard_group_id", using: :btree
  add_index "thredded_messageboards", ["slug"], name: "index_thredded_messageboards_on_slug", using: :btree

  create_table "thredded_notifications_for_followed_topics", force: :cascade do |t|
    t.integer "user_id",                                null: false
    t.string  "notifier_key", limit: 90,                null: false
    t.boolean "enabled",                 default: true, null: false
  end

  add_index "thredded_notifications_for_followed_topics", ["user_id", "notifier_key"], name: "thredded_notifications_for_followed_topics_unique", unique: true, using: :btree

  create_table "thredded_notifications_for_private_topics", force: :cascade do |t|
    t.integer "user_id",                                null: false
    t.string  "notifier_key", limit: 90,                null: false
    t.boolean "enabled",                 default: true, null: false
  end

  add_index "thredded_notifications_for_private_topics", ["user_id", "notifier_key"], name: "thredded_notifications_for_private_topics_unique", unique: true, using: :btree

  create_table "thredded_post_moderation_records", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "messageboard_id"
    t.text     "post_content"
    t.integer  "post_user_id"
    t.text     "post_user_name"
    t.integer  "moderator_id"
    t.integer  "moderation_state",          null: false
    t.integer  "previous_moderation_state", null: false
    t.datetime "created_at",                null: false
  end

  add_index "thredded_post_moderation_records", ["messageboard_id", "created_at"], name: "index_thredded_moderation_records_for_display", order: {"created_at"=>:desc}, using: :btree

  create_table "thredded_post_notifications", force: :cascade do |t|
    t.string   "email",      limit: 191, null: false
    t.integer  "post_id",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "post_type",  limit: 191
  end

  add_index "thredded_post_notifications", ["post_id", "post_type"], name: "index_thredded_post_notifications_on_post", using: :btree

  create_table "thredded_posts", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.string   "ip",               limit: 255
    t.string   "source",           limit: 255, default: "web"
    t.integer  "postable_id",                                  null: false
    t.integer  "messageboard_id",                              null: false
    t.integer  "moderation_state",                             null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "thredded_posts", ["messageboard_id"], name: "index_thredded_posts_on_messageboard_id", using: :btree
  add_index "thredded_posts", ["moderation_state", "updated_at"], name: "index_thredded_posts_for_display", using: :btree
  add_index "thredded_posts", ["postable_id"], name: "index_thredded_posts_on_postable_id_and_postable_type", using: :btree
  add_index "thredded_posts", ["user_id"], name: "index_thredded_posts_on_user_id", using: :btree

  create_table "thredded_private_posts", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.integer  "postable_id",             null: false
    t.string   "ip",          limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "thredded_private_topics", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "last_user_id"
    t.string   "title",        limit: 255,             null: false
    t.string   "slug",         limit: 191,             null: false
    t.integer  "posts_count",              default: 0
    t.string   "hash_id",      limit: 191,             null: false
    t.datetime "last_post_at"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "thredded_private_topics", ["hash_id"], name: "index_thredded_private_topics_on_hash_id", using: :btree
  add_index "thredded_private_topics", ["slug"], name: "index_thredded_private_topics_on_slug", using: :btree

  create_table "thredded_private_users", force: :cascade do |t|
    t.integer  "private_topic_id"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "thredded_private_users", ["private_topic_id"], name: "index_thredded_private_users_on_private_topic_id", using: :btree
  add_index "thredded_private_users", ["user_id"], name: "index_thredded_private_users_on_user_id", using: :btree

  create_table "thredded_topic_categories", force: :cascade do |t|
    t.integer "topic_id",    null: false
    t.integer "category_id", null: false
  end

  add_index "thredded_topic_categories", ["category_id"], name: "index_thredded_topic_categories_on_category_id", using: :btree
  add_index "thredded_topic_categories", ["topic_id"], name: "index_thredded_topic_categories_on_topic_id", using: :btree

  create_table "thredded_topics", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "last_user_id"
    t.string   "title",            limit: 255,                 null: false
    t.string   "slug",             limit: 191,                 null: false
    t.integer  "messageboard_id",                              null: false
    t.integer  "posts_count",                  default: 0,     null: false
    t.boolean  "sticky",                       default: false, null: false
    t.boolean  "locked",                       default: false, null: false
    t.string   "hash_id",          limit: 191,                 null: false
    t.string   "type",             limit: 191
    t.integer  "moderation_state",                             null: false
    t.datetime "last_post_at"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "thredded_topics", ["hash_id"], name: "index_thredded_topics_on_hash_id", using: :btree
  add_index "thredded_topics", ["messageboard_id", "slug"], name: "index_thredded_topics_on_messageboard_id_and_slug", unique: true, using: :btree
  add_index "thredded_topics", ["messageboard_id"], name: "index_thredded_topics_on_messageboard_id", using: :btree
  add_index "thredded_topics", ["moderation_state", "sticky", "updated_at"], name: "index_thredded_topics_for_display", order: {"sticky"=>:desc, "updated_at"=>:desc}, using: :btree
  add_index "thredded_topics", ["user_id"], name: "index_thredded_topics_on_user_id", using: :btree

  create_table "thredded_user_details", force: :cascade do |t|
    t.integer  "user_id",                                 null: false
    t.datetime "latest_activity_at"
    t.integer  "posts_count",                 default: 0
    t.integer  "topics_count",                default: 0
    t.datetime "last_seen_at"
    t.integer  "moderation_state",            default: 1, null: false
    t.datetime "moderation_state_changed_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "thredded_user_details", ["latest_activity_at"], name: "index_thredded_user_details_on_latest_activity_at", using: :btree
  add_index "thredded_user_details", ["moderation_state", "moderation_state_changed_at"], name: "index_thredded_user_details_for_moderations", order: {"moderation_state_changed_at"=>:desc}, using: :btree
  add_index "thredded_user_details", ["user_id"], name: "index_thredded_user_details_on_user_id", using: :btree

  create_table "thredded_user_messageboard_preferences", force: :cascade do |t|
    t.integer  "user_id",                                 null: false
    t.integer  "messageboard_id",                         null: false
    t.boolean  "follow_topics_on_mention", default: true, null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "thredded_user_messageboard_preferences", ["user_id", "messageboard_id"], name: "thredded_user_messageboard_preferences_user_id_messageboard_id", unique: true, using: :btree

  create_table "thredded_user_preferences", force: :cascade do |t|
    t.integer  "user_id",                                 null: false
    t.boolean  "follow_topics_on_mention", default: true, null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "thredded_user_preferences", ["user_id"], name: "index_thredded_user_preferences_on_user_id", using: :btree

  create_table "thredded_user_private_topic_read_states", force: :cascade do |t|
    t.integer  "user_id",                 null: false
    t.integer  "postable_id",             null: false
    t.integer  "page",        default: 1, null: false
    t.datetime "read_at",                 null: false
  end

  add_index "thredded_user_private_topic_read_states", ["user_id", "postable_id"], name: "thredded_user_private_topic_read_states_user_postable", unique: true, using: :btree

  create_table "thredded_user_topic_follows", force: :cascade do |t|
    t.integer  "user_id",              null: false
    t.integer  "topic_id",             null: false
    t.datetime "created_at",           null: false
    t.integer  "reason",     limit: 2
  end

  add_index "thredded_user_topic_follows", ["user_id", "topic_id"], name: "thredded_user_topic_follows_user_topic", unique: true, using: :btree

  create_table "thredded_user_topic_read_states", force: :cascade do |t|
    t.integer  "user_id",                 null: false
    t.integer  "postable_id",             null: false
    t.integer  "page",        default: 1, null: false
    t.datetime "read_at",                 null: false
  end

  add_index "thredded_user_topic_read_states", ["user_id", "postable_id"], name: "thredded_user_topic_read_states_user_postable", unique: true, using: :btree

  create_table "tutors", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "cohort"
  end

  add_index "tutors", ["user_id"], name: "index_tutors_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "uid"
    t.string   "user_name",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "provider",               default: 0
    t.string   "github_link",            default: ""
    t.string   "linkedin_link",          default: ""
    t.string   "blog_link",              default: ""
    t.integer  "program_of_study",       default: 0
    t.text     "self_introduction",      default: ""
    t.string   "slack_id",               default: ""
    t.string   "matric_number",          default: ""
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "admins", "users"
  add_foreign_key "advisers", "users"
  add_foreign_key "evaluatings", "teams", column: "evaluated_id"
  add_foreign_key "evaluatings", "teams", column: "evaluator_id"
  add_foreign_key "facilitators", "users"
  add_foreign_key "feedbacks", "advisers"
  add_foreign_key "feedbacks", "survey_templates"
  add_foreign_key "feedbacks", "teams"
  add_foreign_key "feedbacks", "teams", column: "target_team_id"
  add_foreign_key "mentors", "users"
  add_foreign_key "peer_evaluations", "advisers"
  add_foreign_key "peer_evaluations", "submissions"
  add_foreign_key "peer_evaluations", "teams"
  add_foreign_key "questions", "survey_templates"
  add_foreign_key "registrations", "survey_templates"
  add_foreign_key "registrations", "users"
  add_foreign_key "students", "teams"
  add_foreign_key "students", "users"
  add_foreign_key "submissions", "milestones"
  add_foreign_key "submissions", "teams"
  add_foreign_key "survey_templates", "milestones"
  add_foreign_key "teams", "advisers"
  add_foreign_key "teams", "mentors"
  add_foreign_key "thredded_messageboard_users", "thredded_messageboards"
  add_foreign_key "thredded_messageboard_users", "thredded_user_details"
  add_foreign_key "tutors", "users"
end
