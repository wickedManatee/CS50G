using UnityEngine;
using System.Collections;

public class Collectible : MonoBehaviour {
    public CollectibleType collectibleType;
    public enum CollectibleType { Coin, Gem }
    private int pointValue;

    // Use this for initialization
    void Start () {
        if (collectibleType == CollectibleType.Coin)
            pointValue = 1;
        else if (collectibleType == CollectibleType.Gem)
            pointValue = 5;
    }

	// Update is called once per frame
	void Update () {

		// despawn coin if it goes past the left edge of the screen
		if (transform.position.x < -25) {
			Destroy(gameObject);
		}
		else {

			// ensure coin moves at the same rate as the skyscrapers do
			transform.Translate(-SkyscraperSpawner.speed * Time.deltaTime, 0, 0, Space.World);
		}

		// infinitely rotate this coin about the Y axis in world space
		transform.Rotate(0, 5f, 0, Space.World);
	}

	void OnTriggerEnter(Collider other) {

		// trigger coin pickup function if a helicopter collides with this
		other.transform.parent.GetComponent<HeliController>().PickupCollectible(pointValue);
		Destroy(gameObject);
	}
}
