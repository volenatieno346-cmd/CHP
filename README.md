# CHP Records

An offline-first Flutter app for recording community health visits. Entries are
saved to SQLite before any network request and remain queued across app
restarts.

## Features

- Visit form follows the required schema: `local_id`, `patient_id`, `chw_id`,
  `patient_name`, `village_name`, `visit_type`, `vitals_bp`, `vitals_temp`,
  `urgency_level`, `visit_notes`, `created_at_local`, and `sync_status`.
- Required-field validation, patient-name minimum length, blood-pressure
  format, temperature range, and category choices are checked before saving.
- The queue displays network state and each record's pending/syncing/synced
  status.
- Staff must register or sign in with an employer ID and password before
  accessing patient visits. Session tokens are stored in platform secure
  storage.
- The patient CHW ID is the patient's identity: the app stores the same value
  as `chw_id` and `patient_id`. Reuse it on return visits to associate them
  with one patient entry while keeping each visit separate. Staff IDs are
  used only for staff sign-in.
- Pending records sync in FIFO batches when connectivity returns or when the
  user presses Sync.
- SQLite stores visits in `chw_records.db`, in the `records` table using the
  same columns as the API schema. Patient identities are stored once in the
  `patients` table; existing visits receive migration-only IDs so their data is
  preserved.

## Run the app

Install dependencies and run the app. REST sync defaults to
`localhost:8080` on desktop/iOS simulators and `10.0.2.2:8080` on Android
emulators:

```sh
cd chp
flutter pub get
flutter run
```

For a physical Android phone connected over USB, forward the REST port and use
the phone's loopback address:

```sh
adb reverse tcp:8080 tcp:8080
flutter run -d <device-id> --dart-define=API_HOST=127.0.0.1
```

For a physical phone over Wi-Fi or a remote backend, set `API_HOST` to the
server machine's reachable LAN address, for example
`--dart-define=API_HOST=192.168.1.10`. `10.0.2.2` is only for Android
emulators; it does not reach the development computer from a physical phone.
The REST port defaults to 8080 and can be overridden with `API_PORT`. For
HTTPS, set `--dart-define=API_USE_TLS=true` and configure TLS termination for
the REST API.

## Run the backend

The API requires PostgreSQL and reads its connection string from `DATABASE_URL`.
The configured database must already exist.

```sh
cd Backend
export DATABASE_URL='postgres://USER:PASSWORD@localhost:5432/chp_records?sslmode=disable'
go run .
```

The server creates/migrates the `chp_records`, `chp_patients`, `chp_users`, and
`chp_sessions` tables on startup. Staff register and sign in through
`POST /auth/register` and `POST /auth/login`; `POST /sync` requires the returned
bearer session token, and `POST /auth/logout` revokes it. Passwords are hashed
with bcrypt and session tokens are stored hashed in PostgreSQL. Registration is
open as requested and does not verify employment; restrict registration or add
an employer-issued invite/approval flow before production deployment. On
startup, the app validates a cached session with `/auth/me` when the API is
reachable, but retains it when offline so local entry remains available. Use
HTTPS in production to protect credentials and patient data in transit. The
REST API listens on
port 8080 by default (`PORT`), and the optional gRPC API listens on port 50051
(`GRPC_PORT`). Flutter currently syncs through `POST /sync` and checks
`GET /healthz`. Sync requests carry the same schema as the local SQLite records.
The server validates the batch and inserts it transactionally; `local_id` is a
primary key, so retries are idempotent. The sync response reports received,
inserted, and duplicate counts. The client allows up to 60 seconds per sync
request, and the server logs gRPC batch counts and persistence duration without
logging patient data.

`chp/lib/assets/chw.proto` is the canonical service definition. Regenerate Go
and Dart bindings from the repository root after changing it:

```sh
PATH="$PATH:$(go env GOPATH)/bin:$HOME/.pub-cache/bin" protoc \
  -Ichp/lib/assets \
  --go_out=Backend --go_opt=module=chp/com/server \
  --go-grpc_out=Backend --go-grpc_opt=module=chp/com/server \
  --dart_out=grpc:chp/lib/proto \
  chp/lib/assets/chw.proto
```

## Verify

```sh
cd chp
flutter analyze
flutter test
cd ../Backend
go test ./...
```
