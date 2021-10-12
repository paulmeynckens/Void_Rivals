using System.Collections;
using System.Collections.Generic;
using RoundManagement;
using Core;
using UnityEngine;
using Mirror;

namespace UI.TabPanel
{
    public class ShipIcon : MonoBehaviour
    {
        GameObject ship;
        ShipSpawnLocationHolder shipCrewManager;
        Crew crew=null;

        private void Awake()
        {
            LinkToNetId linkToNetId = GetComponentInParent<LinkToNetId>();
            linkToNetId.OnClientLinkEstablished += SetCrew;
        }

        void SetCrew(uint crewNetId)
        {
            crew = NetworkIdentity.spawned[crewNetId].GetComponent<Crew>();
        }

        private void FixedUpdate()
        {
            if (ship == null)
            {
                Destroy(this);
            }
            if (crew == null)
            {
                return;
            }
            transform.SetParent(CrewIcon.crewsIcons[crew].transform);
            transform.SetAsLastSibling();
            transform.localScale = Vector3.one;
            
        }
        void Destroy()
        {
            Destroy(gameObject);
        }
    }
}

