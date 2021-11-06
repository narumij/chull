
TARGET=chull
PROJECT_PATH=XCFrameworks/${TARGET}/${TARGET}.xcodeproj
BUILD_CONFIGRATION=Release

all: frameworks

frameworks:
	xcodebuild -project $(PROJECT_PATH) -target Aggregate -configuration $(BUILD_CONFIGRATION) clean build
	xcodebuild -project $(PROJECT_PATH) -target Aggregate -configuration $(BUILD_CONFIGRATION) clean

