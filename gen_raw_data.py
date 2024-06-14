from faker import Faker
import csv
import random
from pprint import pprint


def fake_factory(fake: Faker, count: int = 10) -> list[str]:
    return [fake() for i in range(count)]


def create_raw_data(
    rows: int = 100, unique_vals: int = 10
) -> list[list[str, str, str]]:
    fake = Faker()
    # get 10 fake first names
    first_names = fake_factory(fake.first_name, unique_vals)
    states = fake_factory(fake.state, unique_vals)
    genders = ["M", "F"]
    data = []
    for i in range(rows):
        data.append(
            [random.choice(first_names), random.choice(states), random.choice(genders)]
        )
    return data


def save_to_csv(data: list[list[str, str, str]]) -> None:
    with open("raw.csv", "w") as f:
        writer = csv.writer(f)
        writer.writerow(["Name", "State", "Gender"])
        writer.writerows(data)


if __name__ == "__main__":
    data = create_raw_data(4_466_666, 40_000)
    save_to_csv(data)
