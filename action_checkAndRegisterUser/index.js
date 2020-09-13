const fetch = require('node-fetch');

module.exports = async function (context, req) {
  try {
    const { session_variables } = req.body;
    const username = session_variables['x-hasura-user-id'];
    const accessToken = session_variables['x-hasura-access-token'];
    const accessTokenSecret = session_variables['x-hasura-access-token-secret'];
    let affected_rows = 0;

    const client = createClient(req);
    const isUserExists = await userExists(client, username);

    if (!isUserExists) {
      const result = await createUser(client, {
        username,
        accessToken,
        accessTokenSecret,
      });
      affected_rows = result.data.insert_account_user.affected_rows;
    }

    context.res = {
      headers: { 'Content-Type': 'application/json' },
      body: {
        affected_rows,
      },
    };
  } catch (error) {
      console.log(error)
    context.res = {
      headers: { 'Content-Type': 'application/json' },
      status: 400,
      body: error,
    };
    return;
  }
};

function createClient(req) {
  async function client(query, variables) {
    try {
      const result = await fetch(`${process.env.GRAPHQL_BASE_API}/v1/graphql`, {
        method: 'POST',
        body: JSON.stringify({
          query: query,
          variables,
        }),
        headers: { Authorization: req.headers['authorization'] },
      });

      const data = await result.json();
      return data;
    } catch (error) {
      throw error;
    }
  }
  return client;
}

// Check if the user exists
async function userExists(client, username) {
  const GET_USER = `
      query GetUser($username: String) {
        user(where: { username: { _eq: $username } }) {
          username
        }
      }
    `;
  try {
    const result = await client(GET_USER, { username });
    return result.data.user.length > 0;
  } catch (error) {
    throw error;
  }
}

// Create a user
async function createUser(client, payload) {
  const CREATE_ACCOUNT_USER = `
      mutation CreateAccountUser(
        $username: String
        $accessToken: String
        $accessTokenSecret: String
      ) {
        insert_account_user(
          objects: {
            account: {
              data: {
                access_token: $accessToken
                access_token_secret: $accessTokenSecret
                account_name: $username
              }
            }
            user: { data: { username: $username } }
          }
        ) {
          affected_rows
        }
      }
    `;
  try {
    const result = await client(CREATE_ACCOUNT_USER, payload);
    return result;
  } catch (error) {
    throw error;
  }
}
