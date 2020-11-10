import pytest

order_data = {"vehicle_manufacturer": "vauxhal", "model": "vectra", "total_price": 5456}


@pytest.mark.parametrize(
    "order_data, expected_status",
    [
        (order_data, 201),
    ],
)
def test_add_order(client, order_data, expected_status):
    url = "/api/vehicle/order/"
    response = client.post(url, json=order_data)
    assert response.status_code == expected_status


@pytest.mark.parametrize(
    "order_data, expected_status",
    [
        (order_data, 204),
    ],
)
def test_edit_and_retrieve_order(client, order_data, expected_status):
    url = "/api/vehicle/order/"

    # lets first create then store the order id
    order_data["_id"] = prepare_order_id(client.post(url, json=order_data).data)
    url = url + order_data["_id"]
    # now a put
    response = client.put(url, json=order_data)
    assert response.status_code == expected_status
    # and finally a get
    response = client.get(url)
    assert response.status_code == 200


def test_add_order_fail_json(client, mocker):
    # incomplete or wrong params
    order = {"model": "some_model", "price": 100}
    url = "/api/vehicle/order/"
    response = client.post(url, json=order)
    assert response.status_code == 400


def prepare_order_id(response_data):
    return "".join(i for i in response_data.decode("utf-8") if not i in ['"', "\n"])
