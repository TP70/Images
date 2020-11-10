
import pytest

from app.main import init


@pytest.fixture(scope="session")
def app():
    app = init()
    return app
