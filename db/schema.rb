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

ActiveRecord::Schema.define(version: 20161217084309) do

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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "cohort"
  end

  add_index "mentors", ["user_id"], name: "index_mentors_on_user_id", using: :btree

  create_table "milestones", force: :cascade do |t|
    t.datetime "submission_deadline",      default: '2016-12-10 03:56:07', null: false
    t.string   "name"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.datetime "peer_evaluation_deadline", default: '2016-12-10 03:56:07', null: false
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
  end

  add_index "teams", ["adviser_id"], name: "index_teams_on_adviser_id", using: :btree
  add_index "teams", ["mentor_id"], name: "index_teams_on_mentor_id", using: :btree

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
    t.string   "matric_number",          default: ""
    t.string   "slack_id",               default: ""
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
  add_foreign_key "tutors", "users"
end
